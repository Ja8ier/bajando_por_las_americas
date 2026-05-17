local briefing = require("src.scripts.states.minigames.critical core.src.ui.briefing")
local game = require("src.scripts.states.minigames.critical core.src.core.game")

local stateManager = {}

stateManager.currentState = "BRIEFING"

function stateManager.setState(newState)

    stateManager.currentState = newState

    if newState == "PLAYING" then
        game.load()
    end
end

function stateManager.load()

    briefing.load()
end

function stateManager.update(dt)

    if stateManager.currentState == "BRIEFING" then
        briefing.update(dt)

    elseif stateManager.currentState == "PLAYING" then
        game.update(dt)
    end
end

function stateManager.draw()

    if stateManager.currentState == "BRIEFING" then
        briefing.draw()

    elseif stateManager.currentState == "PLAYING" then
        game.draw()
    end
end

function stateManager.keypressed(key)

    if stateManager.currentState == "BRIEFING" then
        briefing.keypressed(key)

    elseif stateManager.currentState == "PLAYING" then
        game.keypressed(key)
    end
end

function stateManager.isExited()
    game.isExited()
end

return stateManager