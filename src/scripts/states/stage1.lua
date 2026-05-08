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

local worldWidth
local layers = {}

--temporal
local enemies = {}

local collisions = {}
local items = {}
local triggers = {}

local scale = love.graphics.getWidth() / 256

local touchingItem
local touchingTrigger
local interactiveObject
local pickableItem
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
    local collisionWorldRightBorder = obstacle.new(false, 2560, 0, 2, 144, "full", "", false, nil)
    local collisionWall1 = obstacle.new(false, 0, 78, 2560, 6, "full", "", false, nil)
    -- local collisionWall2 = obstacle.new(false, 785, 78, 2560, 6, "full", "", false, nil)

    table.insert(collisions, collisionWorldRightBorder)
    table.insert(collisions, collisionWall1)

    --Objetos con textura
    local phoneBooth = obstacle.new(true, 2340, 50, 16, 42, "full", love.graphics.newImage("assets/sprites/items/phone_booth.png"), false, 0.8)
    local object_caucho = obstacle.new(true, 120, 100, 16, 16, "bottom", love.graphics.newImage("assets/sprites/items/caucho.png"), false, nil)

    table.insert(collisions, phoneBooth)
    table.insert(collisions, object_caucho)

    --Items
    local item1 = item.new("disco", 120, 120)
    local item2 = item.new("caucho", 200, 110)

    table.insert(items, item1)
    table.insert(items, item2)

    --Triggers
    local phoneBoothTrigger = trigger.new(nil, nil, nil, nil, true, function() isMiniGamePlaying = true end, true, true, phoneBooth)
    local spawnTrigger = trigger.new(90, 84, 6, 70, true, function () spawnPoint.x = player.x spawnPoint.y = player.y end, true, false, nil)
    local test = trigger.new(500, 84, 6, 70, true, function ()  player.x = spawnPoint.x player.y = spawnPoint.y end, true, false, nil)
    table.insert(triggers, phoneBoothTrigger)
    table.insert(triggers, spawnTrigger)
    table.insert(triggers, test)

   -- enemies temporales
    -- local enemy1 = enemy.new(4, 800, 400, 90, 125, 19, 28)
    -- table.insert(enemies, enemy1)
    -- local enemy2 = enemy.new(3, 600, 400, 90, 125, 19, 28)
    -- table.insert(enemies, enemy2)

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
            if _trigger.item then
                interactiveObject = _trigger
            else
                --activar el onTrigger si está activo del checkpoint
                if _trigger.isActive then
                    _trigger.onTrigger()
                    _trigger.isActive = false
                end
            end
        end
    end

    for i, e in ipairs(enemies) do
        e:update(dt, player)

        e.updateCollisionBox()
        for _, obs in ipairs(collisions) do
            if cb.check(e, obs) then
                cb.resolveX(e, obs)
            end
        end

        e:updateCollisionBox()
        for _, obs in ipairs(collisions) do
            if cb.check(e, obs) then
                cb.resolveY(e, obs)
            end
        end
    end

    for i = #enemies, 1, -1 do
        local e = enemies[i]

        if e.isDead then
            table.remove(enemies, i)
        end
    end

    --actualizar animaciones y sonidos:
    player.updateAnimationState()
    player.update(dt)
    camera.update(player.x, worldWidth * scale)
end

local function printByOrder()

    local drawList = {}

    table.insert(drawList, player)

    for _, e in ipairs(enemies) do
        if not e.isDead then
            table.insert(drawList, e)
        end
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
            love.graphics.setColor(1, 1, 1, 0.25)
            love.graphics.rectangle("fill", obj.collisionBox.x, obj.collisionBox.y, obj.collisionBox.width, obj.collisionBox.height)
            love.graphics.setColor(1, 1, 1)
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

    cb.showBoxes(player, collisions, triggers, false)
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

    if isMiniGamePlaying then
        miniGame.draw(1)
    end

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

    --temporal
    if key == inputs.game.attack then
        for i, e in ipairs(enemies) do
            if mathUtils.getDistanceToPlayer(player, e) <= 75 and e.entityStatus.statusType ~= "stun" then
                player.attacking = true

                e.HP = e.HP - 10

                if e.HP <= 0 then
                    e.isDead = true
                end

                break
            else
                player.attacking = false
            end
        end
    end

end

return stage1