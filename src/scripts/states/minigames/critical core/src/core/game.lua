local reactor = require("src.scripts.states.minigames.critical core.src.reactor.reactor")
local ui = require("src.scripts.states.minigames.critical core.src.ui.ui")
local extraction = require("src.scripts.states.minigames.critical core.src.reactor.extraction")
local events = require("src.scripts.states.minigames.critical core.src.reactor.events")
local screenShake = require("src.scripts.states.minigames.critical core.src.effects.screenShake")
local flicker = require("src.scripts.states.minigames.critical core.src.effects.flicker")
local audio = require("src.scripts.states.minigames.critical core.src.audio.audio")
local reactorRenderer = require("src.scripts.states.minigames.critical core.src.render.reactorRenderer")
local inputs = require("src.scripts.utils.inputs")

local game = {}
local gameState = "playing"
local exit
local gameCompleted = false

-- Variable local para almacenar la textura del fondo
local bgImage

game.gameOver = false
game.victory = false

function game.load()
    exit = false
    audio.play("hum")
    events.load()
    extraction.load()
    reactor.load()
    reactorRenderer.load()
    ui.load()

    -- CARGA DEL FONDO: Cargamos tu sprite hecho a mano
    bgImage = love.graphics.newImage("assets/sprites/miniGames/criticalCore/background/bg_terminal.png")
end

function game.update(dt)

    if exit == true then
        return
    end

    if not reactor.meltdown and not extraction.completed then
        reactor.update(dt)
        extraction.update(dt)
        events.update(dt, reactor)

        if reactor.meltdown then
            game.gameOver = true
        end

        if extraction.completed then
            game.victory = true
            gameCompleted = game.victory
        end
    end

    ui.update(dt)
    flicker.update(dt)
    screenShake.update(dt)

    -- El efecto de sacudida y la alarma SOLO actúan si la partida está en curso
    if not game.gameOver and not game.victory then
        
        -- Temblor intensivo dinámico basado en peligro crítico (>85)
        if reactor.temperature >= 85 or reactor.pressure >= 85 then
            local maxStat = math.max(reactor.temperature, reactor.pressure)
            local dynamicIntensity = 1 + ((maxStat - 85) / 15) * 4
            screenShake.start(0.05, dynamicIntensity)
        end

        -- Gestión de la alarma sonora en peligro
        if reactor.temperature >= 85 or reactor.pressure >= 85 then
            if not audio.sounds.alarm:isPlaying() then
                audio.sounds.alarm:play()
            end
        else
            audio.sounds.alarm:stop()
        end

    else
        -- CONTROL DE FINALIZACIÓN: Forzamos el apagado inmediato si el juego terminó
        audio.sounds.alarm:stop()
        screenShake.duration = 0  -- Detiene en seco cualquier temblor residual
    end

end

function game.draw()

    if exit then
        return
    end

    -- DIBUJO DEL FONDO: Se dibuja siempre de primero para que quede abajo de todo
    -- Al estar aquí, se sacudirá con el screenShake y parpadeará con el flicker perfectamente
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(bgImage, 0, 0)

    -- Ocultamos el reactor y la simulación si la partida terminó para que ui.draw lo muestre limpio
    if not game.gameOver and not game.victory then
        reactor.draw()
        reactorRenderer.draw()
    end
    
    ui.draw()
end

function game.isExited()

    if exit then
        exit = false

        if gameCompleted then
            return true, gameCompleted
        end

        return true, gameCompleted
    end

end

function game.keypressed(key)
    
    if key == inputs.minigames["3"].quit then
        gameCompleted = game.victory == true
        exit = true
    end

    -- La "R" solo responde si el jugador perdió (game.gameOver == true)
    if key == inputs.minigames["3"].restart and game.gameOver then
        reactor.load()
        extraction.load()
        events.load()
        audio.play("beep")
        
        -- Limpieza al reiniciar
        screenShake.duration = 0
        audio.sounds.alarm:stop()

        game.gameOver = false
        game.victory = false
        gameCompleted = game.victory

        return
    end

    -- AJUSTE DE LÓGICA: Los mandos de control solo responden si hay energía disponible
    if reactor.energy > 0 then
        if key == inputs.minigames["3"].q then
            reactor.decreaseCooling()
            audio.play("beep")
        elseif key == inputs.minigames["3"].e then
            reactor.increaseCooling()
            audio.play("beep")
        elseif key == inputs.minigames["3"].a then
            reactor.decreaseVentilation()
            audio.play("beep")
        elseif key == inputs.minigames["3"].d then
            reactor.increaseVentilation()
            audio.play("beep")
        end
    end
end

return game