local screenShake = {}

screenShake.duration = 0
screenShake.intensity = 0

function screenShake.start(duration, intensity)

    screenShake.duration = duration
    screenShake.intensity = intensity
end

function screenShake.update(dt)

    if screenShake.duration > 0 then

        screenShake.duration =
            screenShake.duration - dt
    end
end

function screenShake.apply()

    if screenShake.duration > 0 then

        local offsetX =
            love.math.random(
                -screenShake.intensity,
                screenShake.intensity
            )

        local offsetY =
            love.math.random(
                -screenShake.intensity,
                screenShake.intensity
            )

        love.graphics.translate(
            offsetX,
            offsetY
        )
    end
end

return screenShake