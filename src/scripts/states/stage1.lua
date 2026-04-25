local stage1 = {}

local player = require("src.scripts.entities.player")
local obstacle = require("src.scripts.entities.obstacle")
local camera = require("src.scripts.systems.camera")

local background
local worldWidth
local layers = {}

local obstacles = {}

local scale = love.graphics.getWidth() /256

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
    
    local collision_worldRightBorder = obstacle.new(false, 2560, 0, 2, 144, "full", "", false) -- cerca o pared de atras en zona de la facultad
    table.insert(obstacles, collision_worldRightBorder)
    local collision_wall1 = obstacle.new(false, 0, 78, 2489, 6, "full", "", false) -- cerca o pared de atras en zona de la facultad
    table.insert(obstacles, collision_wall1)

    --Objetos

    local object_caucho = obstacle.new(true, 120, 90, 16, 16, "bottom", love.graphics.newImage("assets/sprites/caucho.png"), false)
    table.insert(obstacles, object_caucho)

    player.load()
end

function stage1.update(dt)

    local cb = require("src.scripts.systems.collision_box")
    --correr con shift
    if love.keyboard.isDown("lshift") then
        player.speed = 300 --velocidad corriendo
    else
        player.speed = 150 --velocidad normal
    end

    --Resolver x
    player.isMoving = false
    player.walk(dt, "x")
    player.updateCollisionBox()

    --Resolver x
    for _, obs in ipairs(obstacles) do
        if cb.check(player, obs) then
            cb.resolveX(player, obs)
        end
    end

    --Resolver y
    player.walk(dt, "y")
    player.updateCollisionBox()

    for _, obs in ipairs(obstacles) do
        if cb.check(player, obs) then
            cb.resolveY(player, obs)
        end
    end

    --actualizar animaciones y sonidos:

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
   
    camera.begin()

    local drawables = {}

    table.insert(drawables, player)

    for _, obs in ipairs(obstacles) do
        if obs.isVisible then
            table.insert(drawables, obs)
        end
    end

    local cb = require("src.scripts.systems.collision_box")
    table.sort(drawables, cb.isAhead)

    for _, obj in ipairs(drawables) do

        if obj == player then
            player.draw()
        else
            obstacle.draw(obj)
        end

    end

    cb.showBoxes(player, obstacles, false)
    camera.ended()

    --frontground
    local frontgroundOffsetX = -camera.x * layers[#layers].factor
    love.graphics.draw(layers[#layers].img, frontgroundOffsetX, 0, 0, scale, love.graphics.getHeight() / 144)

end

return stage1