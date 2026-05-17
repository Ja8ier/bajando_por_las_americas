local buttons = {}
buttons.data = {}

function buttons.load()
    local bx = 400
    local by = 610
    local spacingBtn = 130

    for i = 1, 4 do
        buttons.data[i] = {
            x = bx + (i - 1) * spacingBtn,
            y = by,
            w = 90,
            h = 55,
            hover = false
        }
    end
end

function buttons.update()
    local mx, my = love.mouse.getPosition()

    for _, btn in ipairs(buttons.data) do
        btn.hover = false
        if mx >= btn.x and mx <= btn.x + btn.w and my >= btn.y and my <= btn.y + btn.h then
            btn.hover = true
        end
    end
end

function buttons.draw(buttonFont)
    for i, btn in ipairs(buttons.data) do
        if btn.hover then
            love.graphics.setColor(0, 1, 1)
        else
            love.graphics.setColor(0.3, 0.3, 0.3)
        end

        love.graphics.rectangle("fill", btn.x, btn.y, btn.w, btn.h, 8, 8)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(buttonFont)
        love.graphics.printf(tostring(i), btn.x, btn.y + 18, btn.w, "center")
    end
end

function buttons.checkClick(x, y)
    for i, btn in ipairs(buttons.data) do
        if x >= btn.x and x <= btn.x + btn.w and y >= btn.y and y <= btn.y + btn.h then
            return i
        end
    end
    return nil
end

return buttons