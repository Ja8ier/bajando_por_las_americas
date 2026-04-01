local new_game = {}

local gui = require("src.scripts.gui.gui")
local backgroundSprite

function new_game.load()
    backgroundSprite = love.graphics.newImage("assets/sprites/new_game_background.png")
    backgroundSprite:setFilter("nearest" , "nearest")
end

function new_game.draw()

    love.graphics.draw(backgroundSprite, 0, 0, 0, love.graphics.getWidth()/256, love.graphics.getHeight()/144)
    gui.Draw_button("nuevo juego", 10, 10, 300, 100, 1, 100)

end

function new_game.update(dt)
end

function new_game.resize(w, h)
end

function love.keypressed(key)
    if key == "return" then
        Change_state(require("src.scripts.states.stage1"))
    end
end

return new_game