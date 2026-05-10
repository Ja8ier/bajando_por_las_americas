local item = {}
local itemsDefinition = require("src.scripts.systems.itemsDefinition")

local globalScale = love.graphics.getWidth() / 256

function item.new(itemId, x, y)
    local def = itemsDefinition[itemId]
    if not def then error("Item desconocido: " .. itemId) end
    
    local newItem = {
        id = itemId,
        x = x * globalScale,
        y = y * globalScale,
        sprite = def.texture,
        scale = def.scale or globalScale 
    }

    if type(newItem.sprite) == "userdata" or (type(newItem.sprite) == "table" and newItem.sprite.getWidth) then
        newItem.width = newItem.sprite:getWidth() * newItem.scale
        newItem.height = newItem.sprite:getHeight() * newItem.scale
    else
        newItem.width = 16 * globalScale
        newItem.height = 16 * globalScale
    end

    return newItem
end

function item.draw(self)
    if self.sprite and self.sprite ~= "" then
        love.graphics.draw(self.sprite, self.x, self.y, 0, self.scale, self.scale)
    else
        love.graphics.setColor(1, 0, 1)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        love.graphics.setColor(1, 1, 1)
    end
end

return item