local crt = {}

function crt.draw()

    love.graphics.setColor(
        0,
        0,
        0,
        0.15
    )

    for y = 0, 720, 4 do

        love.graphics.rectangle(
            "fill",
            0,
            y,
            1280,
            2
        )
    end
end

return crt