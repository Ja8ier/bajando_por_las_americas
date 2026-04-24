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
    
    --Background
    layers = {
        {img = love.graphics.newImage("assets/sprites/1.png"), factor = 0.1},
       {img = love.graphics.newImage("assets/sprites/2.png"), factor = 0.4},
       {img = love.graphics.newImage("assets/sprites/3.png"), factor = 1.0}
    }

    --background = love.graphics.newImage("assets/sprites/stage1.png")
    for _, layer in ipairs(layers) do
        layer.img:setFilter("nearest", "nearest")
    end    

    worldWidth = layers[#layers].img:getWidth()

    --Colisiones
    local obs_cerca = obstacle.new(false, 0, 88, 80, 16, "top", "")
    table.insert(obstacles, obs_cerca)

    local obs_cerca2 = obstacle.new(false, 0, 0, 40, 40, "full", "")
    table.insert(obstacles, obs_cerca2)


    player.load()
end

function stage1.update(dt)
    

    local cb = require("src.scripts.systems.collision_box")
    -- --- MOVIMIENTO SHIFT ---
    if love.keyboard.isDown("lshift") then
        player.speed = 300 -- Velocidad de carrera
    else
        player.speed = 150 -- Velocidad normal
    end

    --Resolver x
    player.isMoving = false
    player.walk(dt, "x", worldWidth*scale)
    player.updateCollisionBox() -- Actualizamos la caja tras mover en X
    
    --Resolver x
    for _, obs in ipairs(obstacles) do
        if cb.check(player, obs) then
            cb.resolveX(player, obs)
        end
    end
    
    --Resolver y
    player.walk(dt, "y")
    player.updateCollisionBox() -- Actualizamos la caja tras mover en Y
    
    for _, obs in ipairs(obstacles) do
        if cb.check(player, obs) then
            cb.resolveY(player, obs)
        end
    end
    
    --Actualizar animaciones y sonidos
    
    player.update(dt)
    camera.update(player.x, worldWidth * scale)
end

function stage1.draw()

    --dibujar background
    for _, layer in ipairs(layers) do
        -- Calculamos el desplazamiento individual de cada capa
        local offsetX = -camera.x * layer.factor
        -- Dibujamos la capa con su escala correspondiente
        love.graphics.draw(layer.img, offsetX, 0, 0, scale, love.graphics.getHeight() / 144)
    end

    camera.begin()
    
        player.draw()
        --caja del player
        love.graphics.setColor(1, 1, 1, 0.25)
        love.graphics.rectangle("fill", player.collisionBox.x, player.collisionBox.y, player.collisionBox.width, player.collisionBox.height)
    
        --cajas
        for _, obs in ipairs(obstacles) do
            love.graphics.rectangle("fill", obs.collisionBox.x, obs.collisionBox.y, obs.collisionBox.width, obs.collisionBox.height)
        end
        love.graphics.setColor(1, 1, 1)
    
    camera.ended()

   
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