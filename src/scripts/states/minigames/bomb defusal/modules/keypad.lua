local keypad = {}

keypad.panel = nil
keypad.code = {}
keypad.input = {}
keypad.display = ""
keypad.buttons = {}

-- PANEL POSITION
keypad.panelX = 360
keypad.panelY = 120

-- SCALE
keypad.scale = 0.55

function keypad.load()
    keypad.panel = love.graphics.newImage("assets/images/keypad_panel.png")
    keypad.buttons = {}

    -- BUTTON GRID
    local startX = 558
    local startY = 348
    local size = 40
    local spacing = 66
    local number = 1

    for row = 0, 2 do
        for col = 0, 2 do
            table.insert(keypad.buttons, {
                number = number,
                x = startX + col * spacing,
                y = startY + row * spacing,
                w = size,
                h = size,
                hover = false
            })
            number = number + 1
        end
    end
end

function keypad.generate()
    keypad.code = {}
    keypad.input = {}

    for i = 1, 3 do
        table.insert(keypad.code, tostring(math.random(1, 9)))
    end
    keypad.display = table.concat(keypad.code, " ")
end

function keypad.update()
    local mx, my = love.mouse.getPosition()

    for _, btn in ipairs(keypad.buttons) do
        btn.hover = false
        if mx >= btn.x and mx <= btn.x + btn.w and my >= btn.y and my <= btn.y + btn.h then
            btn.hover = true
        end
    end
end

function keypad.draw(font)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(keypad.panel, keypad.panelX, keypad.panelY, 0, keypad.scale, keypad.scale)
    love.graphics.setFont(font)

    -- DISPLAY CODE
    love.graphics.setColor(0, 1, 0)
    love.graphics.printf(keypad.display, keypad.panelX + 133, keypad.panelY + 25, 300, "center")

    -- PLAYER INPUT
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(table.concat(keypad.input, " "), keypad.panelX + 130, keypad.panelY + 120, 300, "center")

    -- BUTTONS
    for _, btn in ipairs(keypad.buttons) do
        if btn.hover then love.graphics.setColor(0, 1, 1)
        else love.graphics.setColor(0.2, 0.2, 0.2, 0.85)
        end

        love.graphics.rectangle("fill", btn.x, btn.y, btn.w, btn.h, 8, 8)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(tostring(btn.number), btn.x, btn.y + 18, btn.w, "center")
    end
end

function keypad.checkClick(x, y)
    for _, btn in ipairs(keypad.buttons) do
        if x >= btn.x and x <= btn.x + btn.w and y >= btn.y and y <= btn.y + btn.h then
            table.insert(keypad.input, tostring(btn.number))
            local index = #keypad.input

            -- FAIL
            if keypad.input[index] ~= keypad.code[index] then return "fail" end

            -- SUCCESS
            if #keypad.input == #keypad.code then return "success" end

            return "continue"
        end
    end
    return nil
end

function keypad.reset()
    keypad.input = {}
end

return keypad