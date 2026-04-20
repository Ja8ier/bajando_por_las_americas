local obstacleCollisionBox = require("src.scripts.systems.collision_box")
local texture = ""
local scale = love.graphics.getWidth() / 256

local obstacle = {}
 
function obstacle.new(_isVisible, _x, _y, _width, _height, collisionType)
    
    local newObstacle = {
        x = _x,
        y = _y,
        width = _width,
        height = _height,
        scale = scale,
        isVisible = _isVisible
    }
    
    obstacleCollisionBox.create(newObstacle, collisionType)

    return newObstacle
end

return obstacle