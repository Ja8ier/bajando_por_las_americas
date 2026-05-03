local stage1 = {}

local player = require("src.scripts.entities.player")
local obstacle = require("src.scripts.entities.obstacle")
local camera = require("src.scripts.systems.camera")
local inputs = require("src.scripts.utils.inputs")
local item = require("src.scripts.entities.item")
local tableUtils = require("src.scripts.utils.tableUtils")

local worldWidth
local layers = {}

local collisions = {}
local items = {}
local objects = {}

local scale = love.graphics.getWidth() / 256

local touchingItem
local pickableItem

function stage1.load()
    
    --capas del mapa: background, floor, frontground
    layers = {
        {img = love.graphics.newImage("assets/sprites/sky.png"), factor = 0},
       {img = love.graphics.newImage("assets/sprites/mountains.png"), factor = 0},
       {img = love.graphics.newImage("assets/sprites/stage1/stage1_background2.png"), factor = 0.9},
       {img = love.graphics.newImage("assets/sprites/stage1/stage1_background1.png"), factor = 1.0},
       {img = love.graphics.newImage("assets/sprites/stage1/stage1_street.png"), factor = 1.0},
       {img = love.graphics.newImage("assets/sprites/stage1/stage1_frontground.png"), factor = 1.1}
    }

    for _, layer in ipairs(layers) do
        layer.img:setFilter("nearest", "nearest")
    end

    worldWidth = layers[#layers].img:getWidth()

    --Colisiones
    
    local collisionWorldRightBorder = obstacle.new(false, 2560, 0, 2, 144, "full", "", false) -- cerca o pared de atras en zona de la facultad
    table.insert(collisions, collisionWorldRightBorder)
    local collisionWall1 = obstacle.new(false, 0, 78, 2489, 6, "full", "", false) -- cerca o pared de atras en zona de la facultad
    table.insert(collisions, collisionWall1)

    --Objetos

    -- local object_caucho = obstacle.new(true, 120, 90, 16, 16, "bottom", love.graphics.newImage("assets/sprites/caucho.png"), false)
    -- table.insert(obstacles, object_caucho)

    table.insert(items, item.new("disco", 120, 100))

    player.load()
end

function stage1.update(dt)

    local cb = require("src.scripts.systems.collision_box")

    --Resolver x
    player.isMoving = false
    player.move(dt, "x")
    player.updateCollisionBox()

    --Resolver x
    for _, obs in ipairs(collisions) do
        if cb.check(player, obs) then
            cb.resolveX(player, obs)
        end
    end

    --Resolver y
    player.move(dt, "y")
    player.updateCollisionBox()

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

    --actualizar animaciones y sonidos:
    player.updateAnimationState()
    player.update(dt)
    camera.update(player.x, worldWidth * scale)
end

function stage1.draw()

    --dibujar background
    for _, layer in ipairs(layers) do
        --desplazamiento de cada capa
        local offsetX = -camera.x * layer.factor
        love.graphics.draw(layer.img, offsetX, 0, 0, scale, love.graphics.getHeight() / 144)
    end

    --comienzo de la cámara
    camera.begin()

    --tabla a dibujar
    local drawables = {}

    --insercion del player
    table.insert(drawables, player)

    --inserto los obstaculos
    for _, _obstacle in ipairs(collisions) do
        if _obstacle.isVisible then
            table.insert(drawables, _obstacle)
        end
    end

    for _, _item in ipairs(items) do
        table.insert(drawables, _item)
    end

    local cb = require("src.scripts.systems.collision_box")

    table.sort(drawables, cb.isAhead)

    --Dibujar player y luego obstaculos
    for _, obj in ipairs(drawables) do

        if obj == player then
            player.draw()
        elseif obj.collisionBox then
            obstacle.draw(obj)
        else
            item.draw(obj)
        end

    end

    cb.showBoxes(player, collisions, false)
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
end

return stage1