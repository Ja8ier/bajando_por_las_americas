local flicker = {}

flicker.alpha = 0

flicker.timer = 0

function flicker.update(dt)

    flicker.timer =
        flicker.timer + dt

    if flicker.timer >=
    love.math.random(2, 5) then

        flicker.alpha =
            love.math.random(3, 10) / 100

        flicker.timer = 0
    end

    flicker.alpha =
        math.max(
            0,
            flicker.alpha - dt * 0.4
        )
end

function flicker.draw()

    if flicker.alpha > 0 then

        love.graphics.setColor(
            0,
            0,
            0,
            flicker.alpha
        )

        love.graphics.rectangle(
            "fill",
            0,
            0,
            1280,
            720
        )
    end
end

return flicker