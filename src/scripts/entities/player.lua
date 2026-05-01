local sounds = require("src.scripts.sounds.sounds")
local playerCollisionBox = require("src.scripts.systems.collision_box")

local animation = require("src.scripts.systems.animation")

local animations = {
    walk = animation.new("assets/sprites/player/player_walking.png", 19, 28, 0.25, false),
    run = animation.new("assets/sprites/player/player_running.png", 21, 28, 0.15, false)
}

local currentAnimation = animations.walk

local player = {
    x = 0,
    y = 0,
    speed = 150,
    scale = 1,
    width = 19,
    height = 28,

    --sprideSheet base (de pie)
    frameWidth = 19,
    frameheight = 28,
    facingLeft = false,
    isMoving = false,
}

--#region Load, update y draw

function player.load()

    player.scale = (love.graphics.getWidth() / 256)
    player.y = love.graphics.getHeight() - player.frameheight * player.scale - 100
    player.x = 100

    playerCollisionBox.create(player, "bottom")

end

function player.update(dt)

    animation.update(currentAnimation, player.isMoving, dt)

    --logica de sonidos
    -- if player.isMoving then
    -- else
    -- end

end

function player.draw()

    local quad = animation.getQuad(currentAnimation)

    if not quad then
        return
    end
    
    local sheet = animation.getSheet(currentAnimation)

    if player.facingLeft then
        love.graphics.draw(sheet, quad, player.x + player.scale * player.frameWidth,
        player.y, 0, -player.scale, player.scale)
    else
        love.graphics.draw(sheet, quad, player.x, player.y, 0,
        player.scale, player.scale)
    end

end

--#endregion

local function setAnimation(animation)
    local newAnimation = animations[animation]
    if newAnimation and currentAnimation ~= newAnimation then
        currentAnimation = newAnimation
    end
end

function player.updateAnimationState()
    local isShift = love.keyboard.isDown("lshift")
    if player.isMoving then
        player.speed = isShift and 300 or 150
        local anim = isShift and "run" or "walk"
        setAnimation(anim)
    else
        player.speed = 150
        setAnimation("walk")
    end
end

function player.walk(dt, XorY)

    if XorY == "x" then

        if love.keyboard.isDown("a") then
            player.isMoving = true
            player.facingLeft = true
            player.x = math.max(player.x - dt * player.speed, 0)
        elseif love.keyboard.isDown("d") then
            player.isMoving = true
            player.facingLeft = false
            player.x = player.x + dt * player.speed
        end

    elseif XorY == "y" then

        if love.keyboard.isDown("w") then
            player.isMoving = true
            player.y = math.max(player.y - dt * player.speed, 0)
        elseif love.keyboard.isDown("s") then
            player.isMoving = true
            player.y = math.min(player.y + dt * player.speed, love.graphics.getHeight() - player.scale * player.height)
        end

    end

end

return player