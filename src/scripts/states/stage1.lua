local player1 = require("src.scripts.entities.player")

local stage1 = {}
local bg_stage1

function stage1.load()
    bg_stage1 = love.graphics.newImage("assets/sprites/stage1.png")
    bg_stage1:setFilter("nearest", "nearest")

    player1.load()
end


function stage1.update(dt)
    player1.update(dt)
end

function stage1.draw()
    love.graphics.draw(bg_stage1, 0, 0, 0, love.graphics.getWidth()/256, love.graphics.getHeight()/144)

    player1.draw()
end

return stage1