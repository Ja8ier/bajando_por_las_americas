local stage1 = {}

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
local inventory = require("src.scripts.systems.inventory")

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
local openInventory = false
local isMiniGamePlaying
local spawnPoint = {x = 200, y = love.graphics.getHeight() - player.frameheight * player.scale - 300}

function stage1.load()

    isMiniGamePlaying = false

    miniGame.load(1)

    --sirve para que las teclas al presionarlas ejecuten su accion una sola vez en lugar de hacerlo de manera constante
    love.keyboard.setKeyRepeat(false)

    --capas del mapa: background, floor, frontground
    layers = {
        {img = love.graphics.newImage("assets/sprites/sky.png"), factor = 0},
       {img = love.graphics.newImage("assets/sprites/mountains.png"), factor = 0},
       {img = love.graphics.newImage("assets/sprites/stage1/stage1_background2.png"), factor = 0.9},
       {img = love.graphics.newImage("assets/sprites/stage1/stage1_background1.png"), factor = 1.0},
       {img = love.graphics.newImage("assets/sprites/stage1/stage1_street.png"), factor = 1.0},
       {img = love.graphics.newImage("assets/sprites/stage1/stage1_frontground.png"), factor = 1.0}
    }

    worldWidth = layers[#layers].img:getWidth()

    --Cajas de colisiones
    local collisionWorldRightBorder = obstacle.new(false, 2560, 0, 2, 144, "full", "", nil)
    local collisionWall1 = obstacle.new(false, 0, 78, 2560, 6, "full", "", nil)
    -- local collisionWall2 = obstacle.new(false, 785, 78, 2560, 6, "full", "", false, nil)

    table.insert(collisions, collisionWorldRightBorder)
    table.insert(collisions, collisionWall1)

    --Objetos con textura
    local phoneBooth = obstacle.new(true, 2340, 50, 24, 55, "full", love.graphics.newImage("assets/sprites/items/phone_booth.png"), 0.8)
    local wheel = obstacle.new(true, 120, 100, 58, 42, "full", love.graphics.newImage("assets/sprites/items/wheel.png"), 0.5)
    local cono = obstacle.new(true, 200, 100, 24, 30, "bottom", love.graphics.newImage("assets/sprites/items/cono.png"), 0.7)

    table.insert(collisions, phoneBooth)
    table.insert(collisions, wheel)
    table.insert(collisions, cono)

    --Items

    --Triggers
    local phoneBoothTrigger = trigger.new(nil, nil, nil, nil, true, function() isMiniGamePlaying = true end, true, phoneBooth)
    local spawnTrigger = trigger.new(90, 84, 6, 80, true, function () spawnPoint.x = player.x spawnPoint.y = player.y end, true, nil)
    local middleTrigger = trigger.new(1180, 84, 6, 80, true, function () end, true, nil)
    local endTrigger = trigger.new(2100, 84, 6, 80, true, function () end, true, nil)

    table.insert(triggers, phoneBoothTrigger)
    table.insert(triggers, spawnTrigger)
    table.insert(triggers, middleTrigger)
    table.insert(triggers, endTrigger)

   -- enemies temporales
    local enemy1 = enemy.new(4, 800, 400)
    local enemy2 = enemy.new(4, 600, 400)

    table.insert(enemies, enemy2)
    table.insert(enemies, enemy1)
    
    local boss1 = enemy.new(5, 1000, 400)
    table.insert(enemies, boss1)

    player.load(spawnPoint)
end

function stage1.update(dt)

    if isMiniGamePlaying then
        miniGame.update(dt, 1)

        if miniGame.isExited(1) then
            miniGame.load(1)
            isMiniGamePlaying = false
        end

        return
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
                    interactiveObject = _trigger
                else
                    _trigger.onTrigger()
                    _trigger.isActive = false
                end
            end

        end
    end

    for i, e in ipairs(enemies) do
        e:update(dt, player, collisions)
    end

    for i = #enemies, 1, -1 do
        local e = enemies[i]
        
        if e.isDead and e.animationDie then
            if e.tier == 5 then
                NextBossWeaponIndex = NextBossWeaponIndex + 1
            end

            if math.random() <= 1 then
                e:dropItem(items)
            end

            table.remove(enemies, i)
        end
    end

    --actualizar animaciones y sonidos:
    player.updateAnimationState(dt)
    player.update(dt)
    camera.update(player.x, worldWidth * scale)
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
            if obj:draw() then
                obj:draw()
            end
        end

    end

end

function stage1.draw()

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
                love.graphics.print("Presiona ".. inputs.game.interact .. " para interactuar", _trigger.item.x - 100 , _trigger.item.y - 30, 0, 1, 1)
            end
        end
    end

    cb.showBoxes(player, collisions, enemies, triggers, false)
    camera.ended()

    --frontground
    local frontgroundOffsetX = -camera.x * layers[#layers].factor
    love.graphics.draw(layers[#layers].img, frontgroundOffsetX, 0, 0, scale, love.graphics.getHeight() / 144)

    --Barra de vida del player
    love.graphics.draw(love.graphics.newImage("assets/sprites/player_life.png"), 10, 10, 0, scale * 0.8, scale * 0.8)
    love.graphics.setColor(0,1,0.1)
    love.graphics.rectangle("fill", 10, 10 + 32 * scale * 0.8, mathUtils.calculateHealthBarWidth(player.HP, player.maxHP, 32 * scale * 0.8), 15)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", 10, 10 + 32 * scale * 0.8, 32 * scale * 0.8, 15)
    love.graphics.print("Vida:".. player.HP, 10, 25 + 32 * scale * 0.8, 0, 1.08, 0.85)
    
    if openInventory and not player.isDead then
        inventory.draw()
    end

    if isMiniGamePlaying then
        miniGame.draw(1)
    end

end

function stage1.cleanStatus()
    enemies = {}
    collisions = {}
    items = {}
    layers = {}

    touchingItem = false
    pickableItem = nil
    openInventory = false
end

function stage1.keypressed(key)

    if isMiniGamePlaying then
        miniGame.keypressed(key)
        return
    end

    if touchingItem then
        if key == inputs.game.pickUpItem then
            tableUtils.removeByValue(items, pickableItem)
        end
    end

    if touchingTrigger then
        if key == inputs.game.interact then
            interactiveObject.onTrigger()
        end
    end

    if not player.isDead then
        if touchingItem then
            if key == inputs.game.pickUpItem then
                tableUtils.removeByValue(items, pickableItem)
            end
        end

        if key == inputs.game.attack then
            player.attack(enemies)
        end

        if key == inputs.game.openInventory then
            openInventory = not openInventory
        end

        inventory.keypressed(key)
    end
end

return stage1