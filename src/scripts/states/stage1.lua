local player = require("src.scripts.entities.player")
local obstacle = require("src.scripts.entities.obstacle")

local obstacles = {}

local stage1 = {}
local background

local scale = love.graphics.getWidth() /256

function stage1.load()
    background = love.graphics.newImage("assets/sprites/stage1.png")
    background:setFilter("nearest", "nearest")

    local obs1 = obstacle.new(false, 200, 500, 18, 10, "bottom")
    local obs2 = obstacle.new(false, 500, 500, 40, 40, "full")

    table.insert(obstacles, obs1)
    table.insert(obstacles, obs2)

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
    player.walk(dt, "x")
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
end

function stage1.draw()--jjjj
    --dibujar background
    love.graphics.draw(background, 0, 0, 0, love.graphics.getWidth()/256, love.graphics.getHeight()/144)

    --dibujar player
    player.draw()
--caja del player
    love.graphics.setColor(1, 1, 1, 0.25)
    love.graphics.rectangle("fill", player.collisionBox.x, player.collisionBox.y, player.collisionBox.width, player.collisionBox.height)

--cajas
    for _, obs in ipairs(obstacles) do
        love.graphics.rectangle("fill", obs.collisionBox.x, obs.collisionBox.y, obs.collisionBox.width, obs.collisionBox.height)
    end
    love.graphics.setColor(1, 1, 1)
end

return stage1