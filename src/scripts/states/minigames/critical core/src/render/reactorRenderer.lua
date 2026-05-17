local reactor = require("src.scripts.states.minigames.critical core.src.reactor.reactor")

local reactorRenderer = {}

local coreNormall
local coreWarning
local coreCritical

function reactorRenderer.load()

    coreNormal =
        love.graphics.newImage(
            "assets/sprites/miniGames/criticalCore/reactor/core_normal.png"
        )

    coreWarning =
        love.graphics.newImage(
            "assets/sprites/miniGames/criticalCore/reactor/core_warning.png"
        )

    coreCritical =
        love.graphics.newImage(
            "assets/sprites/miniGames/criticalCore/reactor/core_critical.png"
        )
end

function reactorRenderer.draw()

    local currentSprite = coreNormal

    if reactor.temperature >= 85
    or reactor.pressure >= 85 then

        currentSprite = coreCritical

    elseif reactor.temperature >= 65
    or reactor.pressure >= 65 then

        currentSprite = coreWarning
    end

    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(
        currentSprite,
        25,
        370,
        0,
        0.2,
        0.2
    )
end

return reactorRenderer