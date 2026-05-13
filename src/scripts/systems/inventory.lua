local inputs = require("src.scripts.utils.inputs")
local item = require("src.scripts.entities.item")
local itemsDefinition = require("src.scripts.systems.itemsDefinition")

local scale = (love.graphics.getWidth() / 256) * 0.18

local MARGIN = 5 --el margen entre slots
local SLOT_WIDTH = 65 --el ancho de cada slot
local BORDER_RADIUS = 3
local WIDTH = SLOT_WIDTH * 9 + MARGIN * 10
local HEIGHT = SLOT_WIDTH + MARGIN * 2
local POS_X = (love.graphics.getWidth() - WIDTH) / 2
local POS_Y = (love.graphics.getHeight() - HEIGHT - MARGIN)

local previousSlotIndex = 1

local wearBar = {
    wear = 0,
    x = 0,
    y = POS_Y + SLOT_WIDTH - MARGIN,
    width = SLOT_WIDTH - 2 * MARGIN,
    height = MARGIN,
    isVisible = false
}

--Texto que muestra el nombre de los items
local message = {
    text = "",
    x = POS_X + MARGIN,
    y = POS_Y - 7 * MARGIN,
    opacity = 1,
    fadeSpeed = 2,
    active = true
}

local inventory = {
    [1] = {item = nil, isSelected = true},
    [2] = {item = item.new("bat", 0, 0), isSelected = false},
    [3] = {item = nil, isSelected = false},
    [4] = {item = nil, isSelected = false},
    [5] = {item = item.new("knife", 0, 0), isSelected = false},
    [6] = {item = item.new("wrench", 0, 0), isSelected = false},
    [7] = {item = nil, isSelected = false},
    [8] = {item = nil, isSelected = false},
    [9] = {item = item.new("bottle", 0, 0), isSelected = false},
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

--funcion que desgasta el arma con cada golpe
function inventory.wearWeapon(wear)
    for i = 1, 9 do
        if inventory[i].item ~= nil and inventory[i].item.itemType == ITEM_TYPES.WEAPON and
            inventory[i].item.hasWear and inventory[i].isSelected then

                if inventory[i].item.levelOfWear ~= 0 then
                    inventory[i].item.levelOfWear = inventory[i].item.levelOfWear - wear
                    return
                else
                    inventory.remove(inventory[i].item)
                end

        end
    end

end

function inventory.load()

end

function inventory.update(dt)

    if message.active then
        message.opacity = message.opacity - dt / message.fadeSpeed
        if message.opacity <= 0 then
            message.opacity = 0
            message.active = false
        end
    end

end

function inventory.draw()

    for i=1,9 do
        if inventory[i].item ~= nil  and inventory[i].isSelected then
            -- body
            print(inventory[i].item.name .. "=" .. inventory[i].item.levelOfWear)
            break
        end
    end

    love.graphics.setColor(1, 1, 1, 0.09)
    love.graphics.rectangle("fill", POS_X, POS_Y, WIDTH, HEIGHT, BORDER_RADIUS, BORDER_RADIUS)

    -- Slots
    for i = 0, 8 do

        local slotX = POS_X + MARGIN + (i * (SLOT_WIDTH + MARGIN))

        --Imprime el numero del slot:
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(i + 1, slotX + MARGIN, POS_Y + MARGIN, 0, 0.8, 0.8)

        --Imprime el item en el slot:
        if inventory[i + 1].item ~= nil then
            local itemPosY = POS_Y + MARGIN + ((SLOT_WIDTH - inventory[i + 1].item.sprite:getHeight() * scale) / 2)

            love.graphics.draw(inventory[i + 1].item.sprite, slotX + MARGIN, itemPosY, 0, scale, scale)
            love.graphics.setColor(1, 1, 1, 0.15)
        end

        if inventory[i + 1].item ~= nil then

            if inventory[i + 1].item.itemType == ITEM_TYPES.WEAPON and inventory[i + 1].item.hasWear then
    
                wearBar.wear = inventory[i + 1].item.levelOfWear
    
                if inventory[i + 1].item.levelOfWear <= inventory[i + 1].item.levelOfWear * 0.75 then
                    wearBar.width = wearBar.width * 0.75
                    love.graphics.setColor(0.75, 0.7, 0.2)
                elseif inventory[i + 1].item.levelOfWear <= inventory[i + 1].item.levelOfWear * 0.5 then
                    wearBar.width = wearBar.width * 0.5
                    love.graphics.setColor(0.8, 0.5, 0.15)
                elseif inventory[i + 1].item.levelOfWear <= inventory[i + 1].item.levelOfWear * 0.25 then
                    wearBar.width = wearBar.width * 0.25
                    love.graphics.setColor(0.65, 0.25, 0.2)
                else
                    love.graphics.setColor(0.55, 0.75, 0.45)
                end
    
                love.graphics.rectangle("fill", slotX + MARGIN, wearBar.y, wearBar.width, wearBar.height, BORDER_RADIUS, BORDER_RADIUS)
                love.graphics.setColor(1, 1, 1)
            end
            
        end


        --Pone de distinto color el slot seleccionado:
        if inventory[i + 1].isSelected then
            love.graphics.setColor(0, 0.27, 0.67)
        else
            love.graphics.setColor(0, 0, 0, 0.7)
        end

        love.graphics.rectangle("line", slotX, POS_Y + MARGIN, SLOT_WIDTH, SLOT_WIDTH, BORDER_RADIUS, BORDER_RADIUS)

        --Muestra por unos segundos el nombre del item seleccionado
        if inventory[i + 1].isSelected and inventory[i + 1].item ~= nil then
            if message.active or message.opacity > 0 then
                message.text = inventory[i + 1].item.name
                love.graphics.setColor(1, 1, 1, message.opacity)
                love.graphics.print(message.text, message.x, message.y, 0, 1.2, 1)
                love.graphics.setColor(1, 1, 1, 1)
            end
        end

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

    message.active = true
    message.opacity = 1
end

function inventory.keypressed(key)

    for i = 1, 9 do
        if key == inputs.game.slots[i] then
            checkKeySelect(i)
        end
    end

end

return inventory