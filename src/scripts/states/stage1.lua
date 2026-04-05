local player = require("src.scripts.entities.player")

local stage1 = {}
local background

function stage1.load()
    background = love.graphics.newImage("assets/sprites/stage1.png")
    background:setFilter("nearest", "nearest")

    player.load()
end

function stage1.update(dt)
    player.update(dt)
end

function stage1.draw()
    love.graphics.draw(background, 0, 0, 0, love.graphics.getWidth()/256, love.graphics.getHeight()/144)

    player.draw()
end

return stage1