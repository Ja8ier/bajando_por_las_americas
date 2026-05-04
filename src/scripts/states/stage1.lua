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

local worldWidth
local layers = {}

--temporal
local enemies = {}

local collisions = {}
local items = {}
local triggers = {}

local scale = love.graphics.getWidth() / 256

local touchingItem
local pickableItem

function stage1.load()

    --sirve para que las teclas al presionarlas ejecuten su accion una sola vez en lugar de hacerlo de manera constante
    love.keyboard.setKeyRepeat(false)

    --capas del mapa: background, floor, frontground
    layers = {
        {img = love.graphics.newImage("assets/sprites/sky.png"), factor = 0},
       {img = love.graphics.newImage("assets/sprites/mountains.png"), factor = 0},
       {img = love.graphics.newImage("assets/sprites/stage1/stage1_background2.png"), factor = 0.9},
       {img = love.graphics.newImage("assets/sprites/stage1/stage1_background1.png"), factor = 1.0},
       {img = love.graphics.newImage("assets/sprites/stage1/stage1_street.png"), factor = 1.0},
       {img = love.graphics.newImage("assets/sprites/stage1/stage1_frontground.png"), factor = 1.1}
    }

    worldWidth = layers[#layers].img:getWidth()

    --Colisiones
    local collisionWorldRightBorder = obstacle.new(false, 2560, 0, 2, 144, "full", "", false) -- cerca o pared de atras en zona de la facultad
    table.insert(collisions, collisionWorldRightBorder)
    local collisionWall1 = obstacle.new(false, 0, 78, 2489, 6, "full", "", false) -- cerca o pared de atras en zona de la facultad
    table.insert(collisions, collisionWall1)

    --Objetos
    local object_caucho = obstacle.new(true, 120, 90, 16, 16, "bottom", love.graphics.newImage("assets/sprites/items/caucho.png"), false)
    table.insert(collisions, object_caucho)

    --Items
    local item1 = item.new("disco", 120, 120)
    table.insert(items, item1)
    local item2 = item.new("caucho", 200, 110)
    table.insert(items, item2)

    --Triggers
    local triggerTest = trigger.new(nil, nil, nil, nil, false, nil, true, true, object_caucho)
    table.insert(triggers, triggerTest)

    --enemies temporales
    local enemy1 = enemy.new(4, 800, 400, 90, 125, 19, 28)
    table.insert(enemies, enemy1)
    local enemy2 = enemy.new(3, 600, 400, 90, 125, 19, 28)
    table.insert(enemies, enemy2)

    player.load()
end

function stage1.update(dt)

    local cb = require("src.scripts.systems.collision_box")

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

local function printByOrder() --(_player, _enemies, _items, _obstacles)

    local drawList = {}
    local cb = require("src.scripts.systems.collision_box")

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

    local cb = require("src.scripts.systems.collision_box")
    cb.showBoxes(player, collisions, triggers, true)
    camera.ended()

    --frontground
    local frontgroundOffsetX = -camera.x * layers[#layers].factor
    love.graphics.draw(layers[#layers].img, frontgroundOffsetX, 0, 0, scale, love.graphics.getHeight() / 144)

end

function stage1.keypressed(key)

    if touchingItem then
        if key == inputs.game.pickUpItem then
            tableUtils.removeByValue(items, pickableItem)
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

-- function love.keypressed(key)

--     if key == "space" then
--         for i, e in ipairs(enemies) do
--             if mathUtils.getDistanceToPlayer(player, e) <= 75 and e.entityStatus.statusType ~= "stun" then
--                 player.attacking = true

--                 e.HP = e.HP - 10

--                 if e.HP <= 0 then
--                     e.isDead = true
--                 end

--                 break
--             else
--                 player.attacking = false
--             end
--         end
--     end
-- end
return stage1