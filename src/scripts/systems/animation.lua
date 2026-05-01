local Animation = {}

function Animation.new(spritesheet, frameWidth, frameHeight, frameDuration, loop)
    local animation = {
        sheet = love.graphics.newImage(spritesheet),
        quads = {},
        frameWidth = frameWidth,
        frameHeight = frameHeight,
        frameDuration = frameDuration,
        loop = loop,
        currentFrame = 1,
        timer = 0,
    }

    animation.sheet:setFilter("nearest", "nearest")

    local sheetWidth, sheetHeight = animation.sheet:getDimensions()
    local columns = sheetWidth / frameWidth

    for i = 0, columns - 1 do
        animation.quads[i + 1] = love.graphics.newQuad(i * frameWidth, 0,
            frameWidth, frameHeight,sheetWidth, sheetHeight)
    end

    return animation
end

function Animation.update(animation, isMoving, dt)
    
    if not animation then
        return
    end
    
    animation.timer = animation.timer + dt
    
    if animation.timer >= animation.frameDuration then
        animation.timer = animation.timer - animation.frameDuration
        if isMoving or animation.loop then
            animation.currentFrame = (animation.currentFrame % #animation.quads) + 1
        else
            animation.currentFrame = 1

       --     animation.reset(animation)  -- si no se mueve y no loopea, queda en frame 1
        end
    end
end

function Animation.reset(animation)
    if animation then
      --  animation.sheet = "assets/sprites/player/player_walking.png"
        animation.currentFrame = 1
        animation.timer = 0
    end
end

function Animation.setFrameDuration(animation, newDuration)
    if animation then
        animation.frameDuration = newDuration
    end
end

function Animation.getQuad(animation)
    if not animation or not animation.quads[animation.currentFrame] then
        return nil
    end
    return animation.quads[animation.currentFrame]
end

function Animation.getSheet(animation)
    return animation.sheet
end
return Animation