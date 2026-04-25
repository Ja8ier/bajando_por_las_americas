local obstacleCollisionBox = require("src.scripts.systems.collision_box")
local texture = ""
local scale = love.graphics.getWidth() / 256

local obstacle = {}
 
function obstacle.new(_isVisible, _x, _y, _width, _height, collisionType, _texture)
    
    local newObstacle = {
        x = _x * scale,
        y = _y * scale,
        width = _width,
        height = _height,
        scale = scale,
        isVisible = _isVisible,
        texture = _texture
    }
    
    obstacleCollisionBox.create(newObstacle, collisionType)

    return newObstacle
end

function obstacle.draw()
    
end

return obstacle