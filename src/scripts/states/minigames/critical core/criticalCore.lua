local criticalCore = {}
local stateManager = require("src.scripts.states.minigames.critical core.src.core.stateManager")
local audio = require("src.scripts.states.minigames.critical core.src.audio.audio")

function criticalCore.load()
    stateManager.load()
    audio.load()
end

function criticalCore.update(dt)
    stateManager.update(dt)
end

function criticalCore.draw()

    local flicker = require("src.scripts.states.minigames.critical core.src.effects.flicker")
    local crt = require("src.scripts.states.minigames.critical core.src.effects.crt")
    local screenShake = require("src.scripts.states.minigames.critical core.src.effects.screenShake")

    love.graphics.push()
    screenShake.apply()
    stateManager.draw()
    crt.draw()
    flicker.draw()

    love.graphics.pop()
end

function criticalCore.keypressed(key)
    stateManager.keypressed(key)
end

function criticalCore.isExited()
    stateManager.isExited()
end

return criticalCore