local Animation = {}

-- Constructor de una nueva animación
function Animation.new(spritesheetPath, frameWidth, frameHeight, frameDuration, loop)
    local anim = {
        sheet = love.graphics.newImage(spritesheetPath),
        quads = {},
        frameWidth = frameWidth,
        frameHeight = frameHeight,
        frameDuration = frameDuration,
        loop = loop,
        currentFrame = 1,
        timer = 0,
    }
    anim.sheet:setFilter("nearest", "nearest")

    local sheetW, sheetH = anim.sheet:getDimensions()
    local cols = sheetW / frameWidth
    for i = 0, cols - 1 do
        anim.quads[i + 1] = love.graphics.newQuad(
            i * frameWidth, 0,
            frameWidth, frameHeight,
            sheetW, sheetH
        )
    end
    return anim
end

function Animation.update(anim, isMoving, dt)
    if not anim then return end
    anim.timer = anim.timer + dt
    if anim.timer >= anim.frameDuration then
        anim.timer = anim.timer - anim.frameDuration
        if isMoving or anim.loop then
            anim.currentFrame = (anim.currentFrame % #anim.quads) + 1
        else
            anim.currentFrame = 1  -- si no se mueve y no loopea, queda en frame 1
        end
    end
end

function Animation.getQuad(anim)
    if not anim or not anim.quads[anim.currentFrame] then
        return nil
    end
    return anim.quads[anim.currentFrame]
end

function Animation.getSheet(anim)
    return anim.sheet
end

function Animation.reset(anim)
    if anim then
        anim.currentFrame = 1
        anim.timer = 0
    end
end

function Animation.setFrameDuration(anim, newDuration)
    if anim then
        anim.frameDuration = newDuration
    end
end

return Animation