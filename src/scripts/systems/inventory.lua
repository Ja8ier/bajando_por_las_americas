local inventory = {}

local inputs = require("src.scripts.utils.inputs")
local player = require("src.scripts.entities.player")
local item = require("src.scripts.entities.item")

-- El margen inicial dentro del rectángulo grande
local INITIAL_MARGIN = 5
-- El ancho de cada slot + el espacio entre ellos
local SLOT_SPACING = 85

local keyPressed = {false, false, false, false, false, false, false, false, false}
local previousKey = 0

function inventory.load()

end

function inventory.update(dt)

end

function inventory.draw()

    love.graphics.setColor(1, 1, 1, 0.10)
    local startX = (love.graphics.getWidth() - 770) / 2
    love.graphics.rectangle("fill", startX, 620, 770, 90, 10, 10)

    -- Slots
    for i = 0, 8 do
        local slotX = startX + INITIAL_MARGIN + (i * SLOT_SPACING)

        love.graphics.setColor(1, 1, 1, 0.25)
        love.graphics.rectangle("fill", slotX, 625, 80, 80, 10, 10)

        if keyPressed[i + 1] then love.graphics.setColor(0, 1, 0) else love.graphics.setColor(0, 0, 0, 0.8) end

        love.graphics.rectangle("line", slotX, 625, 80, 80, 10, 10)
    end

end

local function checkKeySelect(index)
    keyPressed[index] = true
    if previousKey ~= 0 and index ~= previousKey then keyPressed[previousKey] = false end
    previousKey = index
end

function inventory.keypressed(key)
    if not player.isDead then
        if key ==  inputs.game.slot1 then checkKeySelect(1)
        elseif key ==  inputs.game.slot2 then checkKeySelect(2)
        elseif key ==  inputs.game.slot3 then checkKeySelect(3)
        elseif key ==  inputs.game.slot4 then checkKeySelect(4)
        elseif key ==  inputs.game.slot5 then checkKeySelect(5)
        elseif key ==  inputs.game.slot6 then checkKeySelect(6)
        elseif key ==  inputs.game.slot7 then checkKeySelect(7)
        elseif key ==  inputs.game.slot8 then checkKeySelect(8)
        elseif key ==  inputs.game.slot9 then checkKeySelect(9)
        end
    end
end

return inventory