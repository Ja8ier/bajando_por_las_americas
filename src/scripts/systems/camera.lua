local camera = { x = 0, y = 0 }

function camera.update(targetX, worldWidth)
    local screenWidth = love.graphics.getWidth()
    local leftThreshold = screenWidth * (1/3)
    local rightThreshold = screenWidth * (2/3)

    local playerRelativeX = targetX - camera.x

    if playerRelativeX > rightThreshold then
        camera.x = targetX - rightThreshold
    elseif playerRelativeX < leftThreshold then
        camera.x = targetX - leftThreshold
    end

    camera.x = math.max(0, math.min(camera.x, worldWidth - screenWidth))
end

function camera.begin()
    love.graphics.push()
    love.graphics.translate(-math.floor(camera.x), -math.floor(camera.y))
end

function camera.ended()
    love.graphics.pop()
end

return camera