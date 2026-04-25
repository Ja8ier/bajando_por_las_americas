local obstacleCollisionBox = require("src.scripts.systems.collision_box")
local texture = ""
local scale = love.graphics.getWidth() / 256

local obstacle = {}
 
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

function obstacle.draw(obs)

    if not obs.isVisible then
        return
    end

    if obs.texture and obs.texture ~= "" then
        love.graphics.draw(obs.texture, obs.x, obs.y, 0, obs.scale, obs.scale)
    end

end

return obstacle