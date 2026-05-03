local item = {}
local itemsDefinition = require("src.scripts.systems.itemsDefinition")

local scale = love.graphics.getWidth() / 256

function item.new(itemId, x, y)
    local def = itemsDefinition[itemId]
    if not def then error("Item desconocido: " .. itemId) end
    local newItem = {
        id = itemId,
        x = x * scale,
        y = y * scale,
        width = def.texture:getWidth() * scale,
        height = def.texture:getHeight() * scale,
        sprite = def.texture
    }

    return newItem
end

function item.draw(self)
    if self.sprite then
        -- love.graphics.setColor(1, 0.1, 0.1, 0.25)
        -- love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        -- love.graphics.setColor(1, 1, 1)
         love.graphics.draw(self.sprite, self.x, self.y, 0, scale, scale)
    else
        -- fallback: rectángulo
        love.graphics.rectangle("fill", self.x, self.y, 16, 16)
    end
end

return item