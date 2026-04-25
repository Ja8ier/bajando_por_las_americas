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
    
    local obstacle_worldRightBorder = obstacle.new(false, 2560, 0, 2, 144, "full", "") -- cerca o pared de atras en zona de la facultad
    table.insert(obstacles, obstacle_worldRightBorder)
    local obstacle_wall1 = obstacle.new(false, 0, 78, 2489, 6, "full", "") -- cerca o pared de atras en zona de la facultad
    table.insert(obstacles, obstacle_wall1)

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
    
        player.draw()
        --caja del player
        love.graphics.setColor(1, 1, 1, 0.25)
        love.graphics.rectangle("fill", player.collisionBox.x, player.collisionBox.y, player.collisionBox.width, player.collisionBox.height)
    
        --cajas de colision
        love.graphics.setColor(1, 0.1, 0.1, 0.25)
        for _, obs in ipairs(obstacles) do
            love.graphics.rectangle("fill", obs.collisionBox.x, obs.collisionBox.y, obs.collisionBox.width, obs.collisionBox.height)
        end
        love.graphics.setColor(1, 1, 1)
    
    camera.ended()

    --frontground
    local frontgroundOffsetX = -camera.x * layers[#layers].factor
    love.graphics.draw(layers[#layers].img, frontgroundOffsetX, 0, 0, scale, love.graphics.getHeight() / 144)

    --dibujar player y obstaculos


    -- if player.collisionBox.y > obs.collision_box.y then
    --         --dibujo obstaculos
    --     elseif player.collisionBox.y < obs.collision_box.y then
    --         --dibujo obstaculos
    --         player.draw()
    --     end
        
    -- for _, obs in ipairs(obstacles) do
        
    -- end


end

return stage1