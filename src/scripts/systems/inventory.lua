local inputs = require("src.scripts.utils.inputs")
local item = require("src.scripts.entities.item")
local scale = (love.graphics.getWidth() / 256) * 0.18

local MARGIN = 5 --el margen entre slots
local SLOT_WIDTH = 65 --el ancho de cada slot
local BORDER_RADIUS = 3
local WIDTH = SLOT_WIDTH * 9 + MARGIN * 10
local HEIGHT = SLOT_WIDTH + MARGIN * 2
local POS_X = (love.graphics.getWidth() - WIDTH) / 2
local POS_Y = (love.graphics.getHeight() - HEIGHT - MARGIN)

local previousSlotIndex = 1

local inventory = {
    [1] = {item = item.new("bat", 0, 0), isSelected = true},
    [2] = {item = item.new("wrench", 0, 0), isSelected = false},
    [3] = {item = item.new("knife", 0, 0), isSelected = false},
    [4] = {item = nil, isSelected = false},
    [5] = {item = nil, isSelected = false},
    [6] = {item = nil, isSelected = false},
    [7] = {item = nil, isSelected = false},
    [8] = {item = nil, isSelected = false},
    [9] = {item = nil, isSelected = false},
}

function inventory.insert(_item)

    for i = 1, 9 do
        if inventory[i].item == nil then
            inventory[i].item = _item
            return
        end
    end

end

function inventory.remove(_item)

    for i = 1, 9 do
        if inventory[i].item == _item then
            inventory[i].item = nil
            return _item
        end
    end

end

function inventory.load()

end

function inventory.update(dt)

end

function inventory.draw()

    love.graphics.setColor(1, 1, 1, 0.09)
    love.graphics.rectangle("fill", POS_X, POS_Y, WIDTH, HEIGHT, BORDER_RADIUS, BORDER_RADIUS)

    -- Slots
    for i = 0, 8 do

        local slotX = POS_X + MARGIN + (i * (SLOT_WIDTH + MARGIN))

        love.graphics.setColor(1, 1, 1)
        love.graphics.print(i + 1, slotX + MARGIN, POS_Y + MARGIN, 0, 0.8, 0.8)

        if inventory[i + 1].item ~= nil then
            local itemPosY = POS_Y + MARGIN + ((SLOT_WIDTH - inventory[i + 1].item.sprite:getHeight() * scale) / 2)

            love.graphics.draw(inventory[i + 1].item.sprite, slotX + MARGIN, itemPosY, 0, scale, scale)
            love.graphics.setColor(1, 1, 1, 0.15)
        end

        if inventory[i + 1].isSelected then
            -- love.graphics.setColor(0.12, 0.24, 0.44)
            love.graphics.setColor(0.0, 0.27, 0.67)
        else
            love.graphics.setColor(0, 0, 0, 0.7)
        end

        love.graphics.rectangle("line", slotX, POS_Y + MARGIN, SLOT_WIDTH, SLOT_WIDTH, BORDER_RADIUS, BORDER_RADIUS)

    end

end

function inventory.hasSpace(table)

    for _, i in ipairs(table) do
        if i.item == nil then
            return true
        end
    end

    return false
end

local function checkKeySelect(index)

    inventory[index].isSelected = true

    if previousSlotIndex ~= 0 and index ~= previousSlotIndex then
        inventory[previousSlotIndex].isSelected = false
    end

    previousSlotIndex = index
end

function inventory.keypressed(key)

    for i = 1, 9 do
        if key == inputs.game.slots[i] then
            checkKeySelect(i)
        end
    end

end

return inventory