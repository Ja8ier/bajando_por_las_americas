local stage4 = {}

local player = require("src.scripts.entities.player")
local enemy = require("src.scripts.entities.enemy")
local mathUtils = require("src.scripts.utils.mathUtils")
local obstacle = require("src.scripts.entities.obstacle")
local item = require("src.scripts.entities.item")
local camera = require("src.scripts.systems.camera")
local trigger = require("src.scripts.systems.trigger")
local inputs = require("src.scripts.utils.inputs")
local tableUtils = require("src.scripts.utils.tableUtils")
local miniGame = require("src.scripts.states.minigame")
local cb = require("src.scripts.systems.collision_box")
local GameState = require("src.scripts.data.game_state")
local entitiesData = require("src.scripts.utils.entitiesData")
local sounds = require("src.scripts.sounds.sounds")

local worldWidth
local layers = {}

local enemies = {}
local collisions = {}
local items = {}
local triggers = {}

local scale = love.graphics.getWidth() / 256

local touchingItem
local pickableItem
local touchingTrigger
local interactiveObject
local carryableObject
local isMiniGamePlaying
local wasMiniGamePlaying = false --variable testigo
local spawnPoint = {x = 300, y = love.graphics.getHeight() - player.frameheight * player.scale - 250}
local deadBoss = false
local minigameCompleted = false
local CONSUMIBLE_HP = 300
local font = love.graphics.newFont("assets/fonts/VT323-Regular.ttf", 28)

local function spawnEnemyWave(xStart, xEnd, yMin, yMax, MapEnd)

    local count
    if MapEnd then
        count = math.random(4, 8)
    else
        count = math.random(10, 15)
    end

    local currentTier = math.random(1, 4)--[[ NextBossWeaponIndex or 1 ]]

    local spawnX, spawnY
    for i = 1, count do
        spawnX = math.random(xStart, xEnd)
        spawnY = math.random(yMin, yMax)
        
        local newEnemy = enemy.new(currentTier, spawnX, spawnY)
        
        table.insert(enemies, newEnemy)
    end

    if MapEnd then
        spawnY = math.random(yMin, yMax)
        local boss = enemy.new(5, 12200, spawnY)
        table.insert(enemies, boss)
    end

    print("Invasión generada: " .. count .. " enemigos de Tier " .. currentTier)
end

local function spawnWorldObjects(xStart, xEnd, yMin, yMax, isFinal)
    local enemyCount = isFinal and math.random(5, 8) or math.random(10, 15)
    local obstacleCount = isFinal and math.random(5, 10) or math.random(15, 20)

    local imgWheel = love.graphics.newImage("assets/sprites/items/wheel.png")
    local imgCone = love.graphics.newImage("assets/sprites/items/cono.png")
    local minDistance = 80

    for i = 1, obstacleCount do
        local placed = false
        local attempts = 0
        
        while not placed and attempts < 10 do
            local randX = math.random(xStart, xEnd)
            local randY = math.random(yMin, yMax)
            
            local tooClose = false
            for _, obs in ipairs(collisions) do
                local dx = randX - (obs.x / scale)
                local dy = randY - (obs.y / scale)
                if math.sqrt(dx*dx + dy*dy) < minDistance then
                    tooClose = true
                    break
                end
            end

            if not tooClose then
                local newObs
                if i % 2 == 0 then
                    newObs = obstacle.new(true, randX, randY, 58, 42, "full", imgWheel, 0.5)
                else
                    newObs = obstacle.new(true, randX, randY, 24, 30, "bottom", imgCone, 0.7)
                end
                table.insert(collisions, newObs)
                placed = true
            end
            attempts = attempts + 1
        end
    end
    print("Zona generada: " .. enemyCount .. " enemigos y " .. obstacleCount .. " obstáculos.")
end

local function setCheckpoint()
    spawnPoint.x = player.x
    spawnPoint.y = player.y
    print("Punto de control guardado en: " .. spawnPoint.x .. ", " .. spawnPoint.y)
end

local function carryObjectOnTrigger()
    player.carryObject(collisions, carryableObject.item)
    tableUtils.removeByValue(triggers, carryableObject)
end

local function createObs()
    local sprites1, data1 = entitiesData.generateFixedObstacles(4)
    local sprites2, data2 = entitiesData.generateFixedObstacles(2)
    local sprites3, data3 = entitiesData.generateFixedObstacles(6)

    for _, obs in ipairs(data1) do
        local s = sprites1[obs.t]
        local newObs = obstacle.new(true, obs.x, obs.y, s.w, s.h, s.col, s.img, true, 0.4)
        table.insert(collisions, newObs)
        if obs.t == "cono" then
            local newTrigger = trigger.new(nil, nil, nil, nil, true, carryObjectOnTrigger, true, newObs)
            table.insert(triggers, newTrigger)
        end
    end
    for _, obs in ipairs(data2) do
        local s = sprites2[obs.t]
        local newObs = obstacle.new(true, obs.x, obs.y, s.w, s.h, s.col, s.img, true, 0.4)
        table.insert(collisions, newObs)
        if obs.t == "cono" then
            local newTrigger = trigger.new(nil, nil, nil, nil, true, carryObjectOnTrigger, true, newObs)
            table.insert(triggers, newTrigger)
        end
    end
    for _, obs in ipairs(data3) do
        local s = sprites3[obs.t]
        local newObs = obstacle.new(true, obs.x, obs.y, s.w, s.h, s.col, s.img, true, 0.4)
        table.insert(collisions, newObs)
        if obs.t == "cono" then
            local newTrigger = trigger.new(nil, nil, nil, nil, true, carryObjectOnTrigger, true, newObs)
            table.insert(triggers, newTrigger)
        end
    end
end

function stage4.load()
    enemies = {}  --esto es para que el stage quede limpio, no su dupliquen cajas de colision, no queden triggers invisibles etc
    stage4.enemies = enemies
    local hasSavedEnemies = #GameState.world.savedEnemies > 0
    collisions = {}
    triggers = {}
    items = {}


    isMiniGamePlaying = false

    miniGame.load(1)

    --sirve para que las teclas al presionarlas ejecuten su accion una sola vez en lugar de hacerlo de manera constante
    love.keyboard.setKeyRepeat(false)

    love.graphics.setFont(font)

    --capas del mapa: background, floor, frontground
   layers = {
       {img = love.graphics.newImage("assets/sprites/stage2/mountains2.png"), factor = 0},
       {img = love.graphics.newImage("assets/sprites/stage4/stage4_background.png"), factor = 0.9},
       {img = love.graphics.newImage("assets/sprites/stage4/stage4_street.png"), factor = 1.0},
    }


    worldWidth = layers[#layers].img:getWidth()

    --Cajas de colisiones
    local collisionWorldRightBorder = obstacle.new(false, 2560, 0, 2, 144, "full", "", nil)
    local collisionWall1 = obstacle.new(false, 0, 78, 2560, 6, "full", "", nil)
    -- local collisionWall2 = obstacle.new(false, 785, 78, 2560, 6, "full", "", false, nil)

    table.insert(collisions, collisionWorldRightBorder)
    table.insert(collisions, collisionWall1)

    --Objetos con textura
    local phoneBooth = obstacle.new(true, 1230, 50, 24, 55, "full", love.graphics.newImage("assets/sprites/items/phone_booth.png"), false, 0.8)
--[[     local wheel = obstacle.new(true, 200, 100, 58, 42, "bottom", love.graphics.newImage("assets/sprites/items/wheel.png"), true, 0.5)
    local cone = obstacle.new(true, 1100, 100, 51, 64, "bottom", love.graphics.newImage("assets/sprites/items/cono.png"), true, 0.4)
    local cone2 = obstacle.new(true, 1950, 100, 51, 64, "bottom", love.graphics.newImage("assets/sprites/items/cono.png"), true, 0.4)
    local heavyStone = obstacle.new(true, 380, 108, 64, 53, "full", love.graphics.newImage("assets/sprites/items/heavyStone.png"), false, 0.5) ]]

    table.insert(collisions, phoneBooth)
--[[     table.insert(collisions, wheel)
    table.insert(collisions, cone)
    table.insert(collisions, cone2)
    table.insert(collisions, heavyStone) ]]

    createObs()
    entitiesData.generateItems(4, item, items)

    --Items

    --Triggers
    local phoneBoothTrigger = trigger.new(nil, nil, nil, nil, true, function() isMiniGamePlaying = true end, true, phoneBooth)
    --local coneTrigger = trigger.new(nil, nil, nil, nil, true, carryObjectOnTrigger, true, cone)
    phoneBoothTrigger.id = "stage4_phoneBoothTrigger"

    local minY, maxY = 330, love.graphics.getHeight() - 170 -- este valor modificar a algo mas aceptable

    local spawnTrigger = trigger.new(78, 84, 6, 80, true, function()
        setCheckpoint()
        spawnEnemyWave(500, 5500, minY, maxY, false)
    end, true, nil)
    spawnTrigger.id = "stage4_spawnTrigger"

    local middleTrigger = trigger.new(1180, 84, 6, 80, true, function()
        setCheckpoint()
        spawnEnemyWave(6000, 10000, minY, maxY, false)
    end, true, nil)
    middleTrigger.id = "stage4_middleTrigger"

    local endTrigger = trigger.new(2100, 84, 6, 80, true, function()
        setCheckpoint()
        spawnEnemyWave(10500, 12000, minY, maxY, true)
    end, true, nil)
    endTrigger.id = "stage4_endTrigger"

    table.insert(triggers, phoneBoothTrigger)
    --table.insert(triggers, coneTrigger)
    table.insert(triggers, spawnTrigger)
    table.insert(triggers, middleTrigger)
    table.insert(triggers, endTrigger)

--[[     local arepa = item.new("arepa", 200, 500)
    table.insert(items, arepa) ]]

    if hasSavedEnemies then --reconstruye enemigos desde el json

        for _, savedEnemy in ipairs(GameState.world.savedEnemies) do

            local restoredEnemy = enemy.new(savedEnemy.type, savedEnemy.x, savedEnemy.y)
            restoredEnemy.HP = savedEnemy.hp
            restoredEnemy.id = savedEnemy.id
            table.insert(enemies, restoredEnemy)
        end
    end

    for _, t in ipairs(triggers) do
        if t.id and GameState.world.usedTriggers[t.id] then
            t.isActive = false
        end
    end

    table.insert(items, item.new("bat", spawnPoint.x, spawnPoint.y))

   -- enemies temporales
--[[     local enemy1 = enemy.new(4, 800, 400)
    local enemy2 = enemy.new(1, 700, love.graphics.getHeight() -170)

    table.insert(enemies, enemy2)
    table.insert(enemies, enemy1) 

    local boss1 = enemy.new(5, 900, 400)
    table.insert(enemies, boss1) ]]

    if GameState.player.x ~= 0 and GameState.player.y ~= 0 then --si existe una posicion guardada usa esa
        player.load({                                           -- si no, usa spawn normal
            x = GameState.player.x,
            y = GameState.player.y
        })
    else
        player.load(spawnPoint)
    end

    player.HP = GameState.player.health
    player.maxHP = GameState.player.maxHealth
    player.numberAttempts = GameState.player.attempts
end


local onetime = true

function stage4.update(dt)

    if isMiniGamePlaying and not wasMiniGamePlaying then --detectar el cambio de estado en el audio
        sounds.stopAmbient()
        wasMiniGamePlaying = true
    elseif not isMiniGamePlaying and wasMiniGamePlaying then
        sounds.playAmbient()
        wasMiniGamePlaying = false
    end

    if isMiniGamePlaying then
        miniGame.update(dt, 1)
        local isExit
        isExit, minigameCompleted = miniGame.isExited(1)
        minigameCompleted = minigameCompleted or false
        -- isExit, minigameCompleted = miniGame.isExited(1)
        if isExit then
            miniGame.load(1)
            isMiniGamePlaying = false
        end

        return
    end

    if minigameCompleted and onetime then
        local arepas = {item.new("arepa", 11700, 480), item.new("arepa", 11650, 480), item.new("arepa", 11750, 480)}
        for i, arep in ipairs(arepas) do
            arep.count = 1
            table.insert(items, arep)
        end
        onetime = false
    end

    --Mover x
    player.isMoving = false
    player.move(dt, "x")
    player.updateCollisionBox()

    --Resolver x
    for _, obs in ipairs(collisions) do
        if cb.check(player, obs) then
            cb.resolveX(player, obs)
        end
    end

    --Mover y
    player.move(dt, "y")
    player.updateCollisionBox()

    --Resolver Y
    for _, obs in ipairs(collisions) do
        if cb.check(player, obs) then
            cb.resolveY(player, obs)
        end
    end

    --detección del contacto de un player con un item
    touchingItem = false
    for _, _item in ipairs(items) do
        if cb.checkInteractionCollision(player, _item) then
            touchingItem = true
            pickableItem = _item
            break
        end
    end

    --detección del contacto de un player con un trigger
    touchingTrigger = false
    for _, _trigger in ipairs(triggers) do

        if cb.checkInteractionCollision(player, _trigger) then

            touchingTrigger = true
            if _trigger.isActive then
                if _trigger.item and _trigger.item ~= nil then
                    if _trigger.item.isCarryable then
                        carryableObject = _trigger
                        break
                    end
                    interactiveObject = _trigger
                else
                    _trigger.onTrigger()
                    _trigger.isActive = false

                    if _trigger.id then
                        GameState.world.usedTriggers[_trigger.id] = true
                    end

                    if _trigger.id then
                        GameState.world.usedTriggers[_trigger.id] = true
                    end

                end
            end

        end

    end


    for i, e in ipairs(enemies) do
        e:update(dt, player, collisions, enemies)
    end

    for i = #enemies, 1, -1 do
        local e = enemies[i]

        if e.isDead and e.animationDie then
            if e.tier == 5 then
                NextBossWeaponIndex = NextBossWeaponIndex + 1
                deadBoss = true

                if math.random() <= 1 then
                    e:dropItem(items)
                end
            else
                if math.random() <= 1 then
                    e:dropItem(items)
                end
            end

            table.remove(enemies, i)
        end
    end


   -- CONTROL DE AUDIO INTELIGENTE DE PASOS (CORREGIDO)
    if player.isMoving and not isMiniGamePlaying then
        
        -- Cambiamos la condición para detectar si SHIFT IZQUIERDO está presionado
        -- Nota: Si tus compañeros guardaron la tecla en tus "inputs", puedes usar: love.keyboard.isDown(inputs.game.run)
        if love.keyboard.isDown("lshift") then
            -- Si se mueve y presiona Shift -> Suena correr, se apaga caminar
            sounds.startRunning()
            sounds.stopWalking()
        else
            -- Si se mueve sin Shift -> Suena caminar, se apaga correr
            sounds.startWalking()
            sounds.stopRunning()
        end
    else
        -- Si está completamente quieto o en el minijuego del teléfono público
        sounds.stopWalking()
        sounds.stopRunning()
    end

    --actualizar animaciones y sonidos:
    player.updateAnimationState(dt)
    player.update(dt, enemies)
    camera.update(player.x, worldWidth * scale)
end

function stage4.updateCheckPoint()
    player.x = spawnPoint.x
    player.y = spawnPoint.y
end

local function printByOrder()

    local drawList = {}

    table.insert(drawList, player)

    for _, e in ipairs(enemies) do
        table.insert(drawList, e)
    end

    for _, _obstacle in ipairs(collisions) do
        if _obstacle.isVisible then
            table.insert(drawList, _obstacle)
        end
    end

    for _, _item in ipairs(items) do
        table.insert(drawList, _item)
    end

    table.sort(drawList, cb.isAhead)

    for _, obj in ipairs(drawList) do

        if obj.type then
            if obj.type == "item" then
                item.draw(obj)
            elseif obj.type == "obstacle" then
                obstacle.draw(obj)
            elseif obj.type == "player" then
                obj.draw()
            end

        else
            obj:draw()
        end

    end

end

local function drawPlayerHealthPoints()
    love.graphics.draw(love.graphics.newImage("assets/sprites/player_life.png"), 10, 10, 0, scale * 0.8, scale * 0.8)
    love.graphics.setColor(0.13, 0.55, 0.13) --verde
    love.graphics.rectangle("fill", 10, 10 + 32 * scale * 0.8,
    mathUtils.calculateHealthBarWidth(player.HP, player.maxHP, 32 * scale * 0.8), 15, 4, 4)
    love.graphics.setColor(0.1, 0.1, 0.1) --gris oscuro (casi negro)
    love.graphics.rectangle("line", 10, 10 + 32 * scale * 0.8, 32 * scale * 0.8, 15, 4, 4)
    love.graphics.setColor(0.05, 0.05, 0.05, 0.7) --gris oscuro
    love.graphics.rectangle("fill", 10, 25 + 32 * scale * 0.8, 32 * scale * 0.8, 30, 2, 2)
    love.graphics.setColor(0.75, 0.75, 0.75)--gris claro (casi blanco)
    love.graphics.print("Salud:".. player.HP, 20, 25 + 32 * scale * 0.8, 0, 1, 0.9)
    love.graphics.setColor(1, 1, 1)
end

function stage4.draw()

    love.graphics.setColor(1, 1, 1)

    --dibujar background
    for _, layer in ipairs(layers) do
        --desplazamiento de cada capa
        local offsetX = -camera.x * layer.factor
        love.graphics.draw(layer.img, offsetX, 0, 0, scale, love.graphics.getHeight() / 144)
    end

    --comienzo de la cámara
    camera.begin()

    printByOrder()

    for _, _trigger in ipairs(triggers) do
        if cb.checkInteractionCollision(player, _trigger) then

            if _trigger.item then
                if _trigger.item.isCarryable then
                    love.graphics.print("Presiona ".. string.upper(inputs.game.carryObject) .. " para recoger", _trigger.item.x - 80 , _trigger.item.y - 30, 0, 1, 1)
                    break
                end
                love.graphics.print("Presiona ".. inputs.game.interact .. " para interactuar", _trigger.item.x - 100 , _trigger.item.y - 30, 0, 1, 1)
            end
        end
    end

    cb.showBoxes(player, collisions, enemies, triggers, false)
    camera.ended()

    --Barra de vida del player
    drawPlayerHealthPoints()

    if player.isCarringObject then
        love.graphics.setColor(1,1,1)
        love.graphics.print("Presiona ".. string.upper(inputs.game.attack) .. " para lanzar", love.graphics.getWidth() - 250, 0, 0, 1, 1)
        love.graphics.setColor(1,1,1)
    end

    player.inventory.draw()

    if isMiniGamePlaying then
        miniGame.draw(1)
    end

end

function stage4.cleanStatus()
    layers = {}
    enemies = {}
    collisions = {}
    items = {}
    triggers = {}

    touchingTrigger = false
    interactiveObject = nil
    isMiniGamePlaying = false
    touchingItem = false
    pickableItem = nil
    deadBoss = false
    spawnPoint = {x = 500, y = love.graphics.getHeight() - player.frameheight * player.scale - 300}
end

function stage4.keypressed(key)

    if not player.isDead then

        if isMiniGamePlaying then
            miniGame.keypressed(key)
            return
        end

        if touchingItem then

            if key == inputs.game.pickUpItem then
                player.pickItem(items, pickableItem, player.inventory)
                return
            end

        end

        if key == inputs.game.useItem then

            if player.inventory.getItemSelectSlot() ~= nil and 
                player.inventory.getItemSelectSlot().itemType == ITEM_TYPES.CONSUMIBLE then

                player.inventory.remove(player.inventory.getItemSelectSlot())

                if player.HP ~= 1500 then
                    if player.HP + CONSUMIBLE_HP > 1500 then
                        player.HP = 1500
                    else
                        player.HP = player.HP + CONSUMIBLE_HP
                    end
                end

            end

        end

        if key == inputs.game.dropItem then
            player.dropItem(items, player.inventory)
            return
        end

        if key == inputs.game.carryObject then
            if not player.isCarringObject then
                if not player.isThrowing() then
                    if carryableObject ~= nil and carryableObject.item ~= nil and
                        carryableObject.item.isCarryable then
                        carryableObject.onTrigger()
                        carryableObject = nil
                    end
                else
                    print("no puedes recoger objetos lanzas")
                end
            else
                -- dejar objeto
                local newObject = player.leaveObject()
                local newTrigger = trigger.new(nil, nil, nil, nil, true, carryObjectOnTrigger, true, newObject)
                table.insert(collisions, newObject)
                table.insert(triggers, newTrigger)
                player.isCarringObject = false
            end
            return
        end

        if touchingTrigger then

            if key == inputs.game.interact then

                if interactiveObject ~= nil and not interactiveObject.isCarryable then
                    interactiveObject.onTrigger()
                    interactiveObject = nil
                end

            end

            if key == inputs.game.carryObject then
                if not player.isCarringObject then
                    if carryableObject ~= nil and carryableObject.item ~= nil and
                    carryableObject.item.isCarryable then
                        carryableObject.onTrigger()
                        carryableObject = nil
                    end
                end

            end

        end

        if key == inputs.game.attack then
            sounds.play(sounds.sound_effects.hit)
            player.attack(enemies)
            player.inventory.wearWeapon(player.getWearLosen())
        end

        player.inventory.keypressed(key)

    end

end

function stage4.mousepressed(x, y, button)
    if isMiniGamePlaying then
        miniGame.mousepressed(x, y, button)
        return
    end
end

function stage4.continueGame()
    if minigameCompleted then
        return true
    end
    return false
end

stage4.enemies = enemies


return stage4