local effects = {}

effects.shakeTimer = 0
effects.shakeIntensity = 0
effects.flashAlpha = 0
effects.flashSpeed = 0

-- SHAKE
function effects.triggerShake(power, duration)
    effects.shakeIntensity = power
    effects.shakeTimer = duration or 0.25
end

function effects.update(dt)
    -- SHAKE
    if effects.shakeTimer > 0 then
        effects.shakeTimer = effects.shakeTimer - dt
        if effects.shakeTimer <= 0 then effects.shakeIntensity = 0 end
    end

    -- FLASH
    if effects.flashAlpha > 0 then
        effects.flashAlpha = effects.flashAlpha - effects.flashSpeed * dt
        if effects.flashAlpha < 0 then effects.flashAlpha = 0 end
    end
end

function effects.getShakeOffset()
    local offsetX, offsetY = 0, 0
    if effects.shakeTimer > 0 then
        offsetX = love.math.random(-effects.shakeIntensity, effects.shakeIntensity)
        offsetY = love.math.random(-effects.shakeIntensity, effects.shakeIntensity)
    end
    return offsetX, offsetY
end

-- RED DAMAGE FLASH
function effects.triggerFlash(alpha, speed)
    effects.flashAlpha = alpha or 0.6
    effects.flashSpeed = speed or 2.5
end

function effects.drawFlash()
    if effects.flashAlpha <= 0 then return end

    love.graphics.setColor(1, 0, 0, effects.flashAlpha)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

-- LOW TIME WARNING
function effects.drawLowTimeWarning(timer)
    if timer > 10 then return end

    local pulse = math.abs(math.sin(love.timer.getTime() * 7))
    love.graphics.setColor(1, 0, 0, 0.08 + pulse * 0.12)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

-- SCANLINES
function effects.drawScanlines()
    love.graphics.setColor(0, 0, 0, 0.08)
    for y = 0, love.graphics.getHeight(), 4 do
        love.graphics.rectangle("fill", 0, y, love.graphics.getWidth(), 2)
    end
end

return effects