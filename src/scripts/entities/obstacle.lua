local obstacleCollisionBox = require("src.scripts.systems.collision_box")
local texture = ""
local scale = love.graphics.getWidth() / 256

local obstacle = {
    x = 0,
    y = 0,
    width = 0,
    height = 0,
    scale = 1,
    isVisible = false
}
 
function obstacle.load(_isVisible, _x, _y, _width, _height, collisionType)

    obstacle.isVisible = _isVisible
    obstacle.scale = scale
    
    obstacle.x = _x
    obstacle.y = _y
    obstacle.width = _width
    obstacle.height = _height

    obstacleCollisionBox.create(obstacle, collisionType)

end

function obstacle.update(dt)
    
end

function obstacle.draw()
    
end

return obstacle