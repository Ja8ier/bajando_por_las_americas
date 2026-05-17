local bars = {}

function bars.drawBar(x, y, width, height, value, maxValue, label)

    local percentage = value / maxValue

    -- Border
    love.graphics.setColor(0, 1, 0)

    love.graphics.rectangle(
        "line",
        x,
        y,
        width,
        height
    )

    -- Fill
    local fillWidth = width * percentage

    -- Dynamic colors
    if percentage >= 0.7 then

        love.graphics.setColor(1, 0, 0)

    elseif percentage >= 0.4 then

        love.graphics.setColor(1, 1, 0)

    else

        love.graphics.setColor(0, 1, 0)
    end

    love.graphics.rectangle(
        "fill",
        x,
        y,
        fillWidth,
        height
    )

    -- Text
    love.graphics.setColor(0, 1, 0)

    love.graphics.print(
        label ..
        ": " ..
        math.floor(value),
        x,
        y - 25
    )
end

return bars