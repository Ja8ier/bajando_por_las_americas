local wires = {}

local wireColors = { "red", "blue", "green", "yellow" }
wires.data = {}

function wires.load(wireSprites)
    local startX = 310
    local startY = 290
    local spacing = 85

    for i, color in ipairs(wireColors) do
        wires.data[color] = {
            x = startX,
            y = startY + (i - 1) * spacing,
            width = 660,
            height = 40,
            color = color,
            hover = false
        }
    end

    wires.sprites = wireSprites
end

function wires.update()
    local mx, my = love.mouse.getPosition()

    for _, wire in pairs(wires.data) do
        wire.hover = false
        if mx >= wire.x and mx <= wire.x + wire.width and my >= wire.y and my <= wire.y + wire.height then
            wire.hover = true
        end
    end
end

function wires.draw()
    for color, wire in pairs(wires.data) do
        local sprite = wires.sprites[color]
        local scaleX = wire.width / sprite:getWidth()
        local scaleY = wire.height / sprite:getHeight()

        if wire.hover then
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(sprite, wire.x - 10, wire.y - 5, 0, scaleX * 1.03, scaleY * 1.15)
        else
            love.graphics.setColor(0.95, 0.95, 0.95)
            love.graphics.draw(sprite, wire.x, wire.y, 0, scaleX, scaleY)
        end
    end
end

function wires.checkClick(x, y)
    for color, wire in pairs(wires.data) do
        if x >= wire.x and x <= wire.x + wire.width and y >= wire.y and y <= wire.y + wire.height then
            return color
        end
    end
    return nil
end

return wires