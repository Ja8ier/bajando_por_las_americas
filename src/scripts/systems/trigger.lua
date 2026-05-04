local cb = require("src.scripts.systems.collision_box")
local scale = love.graphics.getWidth() / 256

local trigger = {}

function trigger.new(_x, _y, _width, _height, _isActive, _onTrigger, _isVisible, _applyToItem, _item)

    local applyToItemAux = false

    if _applyToItem then
        local edgeWidth = 6
        applyToItemAux = true

        if _item.collisionBox then
            _x = _item.collisionBox.x / scale - edgeWidth
            _y = _item.collisionBox.y / scale - edgeWidth
            _width = _item.collisionBox.width / scale + edgeWidth * 2
            _height = _item.collisionBox.height / scale + edgeWidth * 2
        else
            _x = _item.x / scale - edgeWidth
            _y = _item.y / scale - edgeWidth
            _width = _item.width / scale + edgeWidth * 2
            _height = _item.height / scale + edgeWidth * 2
        end

    end

    local newTrigger = {
        x = _x * scale,
        y = _y * scale,
        width = _width * scale,
        height = _height * scale,
        isActive = _isActive,
        onTrigger = _onTrigger,
        isVisible = _isVisible,
    }

    if applyToItemAux then
        newTrigger.item = _item
    end

    return newTrigger
end

-- function stage1.update(dt)
--     -- ... actualizaciones normales ...
--     for _, trig in ipairs(triggers) do
--         if trig.active and checkBasicCollision(player, trig) then
--             trig.onTrigger()
--             trig.active = false -- para que no se dispare cada frame
--         end
--     end
-- end

return trigger