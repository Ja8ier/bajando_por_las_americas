local player = require("src.scripts.entities.player")
local obstacle = require("src.scripts.entities.obstacle")

local stage1 = {}
local background

local scale = love.graphics.getWidth() /256

function stage1.load()
    background = love.graphics.newImage("assets/sprites/stage1.png")
    background:setFilter("nearest", "nearest")

    obstacle.load(false, 500, 400, 18, 10, "bottom")
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
    -- ----------------------------------------


    -- 1. Movimiento y resolución en EJE X
    player.isMoving = false
    player.walk(dt, "x")
    player.updateCollisionBox() -- Actualizamos la caja tras mover en X
    
    if cb.check(player, obstacle) then
        cb.resolveX(player, obstacle)
    end

    -- 2. Movimiento y resolución en EJE Y
    player.walk(dt, "y")
    player.updateCollisionBox() -- Actualizamos la caja tras mover en Y
    
    if cb.check(player, obstacle) then
        cb.resolveY(player, obstacle)
    end
    
    -- 3. Actualizar animaciones y sonidos (esto estaba dentro de player.update)
    player.updateAnimation(dt) -- Si separas la lógica de animación en player.lua
end

-- function stage1.update(dt)
--     local oldX = player.x
--     local oldY = player.y

--     player.update(dt)

--     local cb = require("src.scripts.systems.collision_box")


--     if cb.check(player, obstacle) then
--         if cb.whereItComes(player, oldX, oldY) == "right" or cb.whereItComes(player, oldX, oldY) == "left" then
--             cb.resolveX(player, obstacle)
--         elseif cb.whereItComes(player, oldX, oldY) == "up" or cb.whereItComes(player, oldX, oldY) == "down" then
--             cb.resolveY(player, obstacle)
--         end
--     end

-- end

function stage1.draw()
    love.graphics.draw(background, 0, 0, 0, love.graphics.getWidth()/256, love.graphics.getHeight()/144)

    player.draw()
    love.graphics.print(player.collisionBox.type, 10, 10)

    love.graphics.setColor(1, 1, 1, 0.25)
    love.graphics.rectangle("fill", player.collisionBox.x, player.collisionBox.y, player.collisionBox.width, player.collisionBox.height)
    --love.graphics.setColor(1, 1, 1)

    --obstacle.draw()
    --love.graphics.setColor(1, 1, 1, 0.25)
    love.graphics.rectangle("fill", obstacle.collisionBox.x, obstacle.collisionBox.y, obstacle.collisionBox.width, obstacle.collisionBox.height)
    love.graphics.setColor(1, 1, 1)
end

return stage1