local sounds = require("src.scripts.sounds.sounds")
local playerCollisionBox = require("src.scripts.systems.collision_box")

local currentFrame = 1
local frameDuration = 0.25
local timer = 0
local columns = 0

local sprideSheet = ""

local sheetWidth = 0
local sheetHeight = 0

local quads = {}

local player = {
    x = 0,--ddn
    y = 0,
    speed = 150,
    scale = 1,
    width = 19,
    height = 28,

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
    
    sheetWidth, sheetheight = sprideSheet:getDimensions()
    columns = sheetWidth / player.frameWidth

    for i = 0, columns - 1 do
        quads[#quads+1] = love.graphics.newQuad(i * player.frameWidth, 0, player.frameWidth, player.frameheight, sheetWidth, sheetheight)
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
end

function player.draw()
    if player.facingLeft then
        love.graphics.draw(sprideSheet, quads[currentFrame], player.x + player.scale * player.frameWidth, player.y, 0, -player.scale, player.scale)
    else
        love.graphics.draw(sprideSheet, quads[currentFrame], player.x, player.y, 0, player.scale, player.scale)
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

return player