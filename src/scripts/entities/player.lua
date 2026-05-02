local sounds = require("src.scripts.sounds.sounds")
local playerCollisionBox = require("src.scripts.systems.collision_box")
local mathUtils = require("src.scripts.utils.mathUtils")

local currentFrame = 1
local frameDuration = 0.25
local timer = 0
local columns = 0

local sprideSheet = ""

local sheetWidth = 0
local sheetHeight = 0
local deathEffect = {0,0,0}

local quads = {}

local player = {
    x = 0,
    y = 0,
    speed = 150,
    scale = 1,
    HP = 1000,
    maxHP = 1000,
    cover = false,
    --son las dimensiones de las collision_box
    boxWidth = 19,
    boxHeight = 28,

    --sprideSheet
    frameWidth = 19,
    frameheight = 28,
    facingLeft = false,
    isMoving = false,
}

--#region Load, update y draw

function player.load()

    player.scale = (love.graphics.getWidth() / 256)
    player.y = love.graphics.getHeight() - player.frameheight * player.scale - 100

    sprideSheet = love.graphics.newImage("assets/sprites/player_walking.png")
    sprideSheet:setFilter("nearest" , "nearest")
    
    sheetWidth, sheetHeight = sprideSheet:getDimensions()
    columns = sheetWidth / player.frameWidth

    for i = 0, columns - 1 do
        quads[#quads+1] = love.graphics.newQuad(i * player.frameWidth, 0, player.frameWidth, player.frameheight, sheetWidth, sheetHeight)
    end
    
    playerCollisionBox.create(player, "bottom")
end

function player.update(dt)

    timer = timer + dt

    --logica de sonidos
    if player.isMoving then
        sounds.sound_effects.pasos2:play()
    else
        sounds.sound_effects.pasos2:stop()
    end

    --logica de animación
    if timer >= frameDuration then
        timer = timer - frameDuration
        if player.isMoving then
            currentFrame = (currentFrame % #quads) + 1
        else
            currentFrame = 1
        end
    end

    player.checkDeath(dt)

end

function player.draw()

    love.graphics.setColor(0,1,0)
    love.graphics.rectangle("fill", player.x, player.y - 50, mathUtils.calculateHealthBarWidth(player.HP, player.maxHP), 15)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", player.x, player.y - 50, 100, 15)
        love.graphics.print(player.HP, player.x, player.y - 73, 0, 0.7)

    if player.facingLeft then
        love.graphics.draw(sprideSheet, quads[currentFrame], player.x + player.scale * player.frameWidth, player.y, 0, -player.scale, player.scale)
    else
        love.graphics.draw(sprideSheet, quads[currentFrame], player.x, player.y,
                            deathEffect[1], player.scale, player.scale, deathEffect[2], deathEffect[3])
    end
end

--#endregion

function player.move(dt)

    if love.keyboard.isDown("lshift") then
        player.speed = 300
        frameDuration = 0.10
    else
        player.speed = 150
        frameDuration = 0.25
    end

    player.walk(dt, "x")
    player.walk(dt, "y")

end

function player.walk(dt, XorY)
    if XorY == "x" then
        if love.keyboard.isDown("a") then
            player.isMoving = true
            player.facingLeft = true
            player.x = player.x - dt * player.speed
        elseif love.keyboard.isDown("d") then
            player.isMoving = true
            player.facingLeft = false
            player.x = player.x + dt * player.speed
        end
    elseif XorY == "y" then
        if love.keyboard.isDown("w") then
            player.isMoving = true
            player.y = player.y - dt * player.speed
        elseif love.keyboard.isDown("s") then
            player.isMoving = true
            player.y = player.y + dt * player.speed
        end
    end
end

function player.checkDeath(dt)
    if player.HP <= 0 then
        player.HP = 0
        player.die(dt)
    end
end

function player.die(dt)
    deathEffect = {3/2 * math.pi, 32, 10}
end

return player