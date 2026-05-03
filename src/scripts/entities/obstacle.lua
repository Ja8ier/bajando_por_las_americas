local obstacle = {}

local obstacleCollisionBox = require("src.scripts.systems.collision_box")
local texture = ""
local scale = love.graphics.getWidth() / 256
 
function obstacle.new(_isVisible, _x, _y, _width, _height, collisionType, _texture, _isInteractive)
    
    local newObstacle = {
        x = _x * scale,
        y = _y * scale,
        width = _width,
        height = _height,
        scale = scale,
        isVisible = _isVisible,
        texture = _texture,
        isInteractive = _isInteractive
    }
    
    obstacleCollisionBox.create(newObstacle, collisionType)

    return newObstacle
end

function obstacle.draw(_obstacle)

    if not _obstacle.isVisible then
        return
    end

    if _obstacle.texture and _obstacle.texture ~= "" then
        love.graphics.draw(_obstacle.texture, _obstacle.x, _obstacle.y, 0, _obstacle.scale, _obstacle.scale)
    end

end

return obstacle