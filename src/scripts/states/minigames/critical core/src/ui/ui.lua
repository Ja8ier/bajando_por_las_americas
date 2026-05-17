local reactor = require("src.scripts.states.minigames.critical core.src.reactor.reactor")
local bars = require("src.scripts.states.minigames.critical core.src.ui.bars")
local extraction = require("src.scripts.states.minigames.critical core.src.reactor.extraction")
local events = require("src.scripts.states.minigames.critical core.src.reactor.events")

local ui = {}

local font
local warningVisible = true
local warningTimer = 0

function ui.load()

    font = love.graphics.newFont(
        "assets/fonts/terminal.ttf",
        14
    )
end

function ui.update(dt)
    warningTimer = warningTimer + dt

    if warningTimer >= 0.5 then

        warningVisible = not warningVisible

        warningTimer = 0
    end

end

function ui.draw() 

    love.graphics.setFont(font)

    -- AJUSTE: Todo esto solo se dibuja si el juego sigue en curso
    if not reactor.meltdown and not extraction.completed then

        -- Background panel
        love.graphics.setColor(0, 0.15, 0)

        love.graphics.rectangle(
            "fill",
            30,
            30,
            500,
            320
        )

        -- Border
        love.graphics.setColor(0, 1, 0)

        love.graphics.rectangle(
            "line",
            30,
            30,
            500,
            320
        )

        -- Bars
        bars.drawBar(
            60,
            80,
            400,
            20,
            reactor.temperature,
            100,
            "TEMPERATURA"
        )

        bars.drawBar(
            60,
            140,
            400,
            20,
            reactor.pressure,
            100,
            "PRESION"
        )

        bars.drawBar(
            60,
            200,
            400,
            20,
            reactor.energy,
            100,
            "ENERGIA"
        )

        bars.drawBar(
            60,
            260,
            400,
            20,
            reactor.stability,
            100,
            "ESTABILIDAD"
        )

        love.graphics.setColor(0, 1, 0)

        love.graphics.print(
            "ENFRIAMIENTO: " ..
            reactor.coolingLevel,
            600,
            100
        )

        love.graphics.print(
            "VENTILACION: " ..
            reactor.ventilationLevel,
            600,
            160
        )

        love.graphics.print(
            "Q/E AJUSTAR ENFRIAMIENTO",
            600,
            300
        )

        love.graphics.print(
            "A/D AJUSTAR VENTILACION",
            600,
            360
        )

        love.graphics.print(
            "Presiona CTRL para salir",
            love.graphics.getWidth() - 420,
            love.graphics.getHeight() - 30
        )

        love.graphics.setColor(0, 1, 0)

        love.graphics.print(
            "EXTRACCION EN: " ..
            extraction.getFormattedTime(),
            850,
            50
        )

        -- Critical warnings

        if reactor.temperature >= 80 and warningVisible then

            love.graphics.setColor(1, 0, 0)

            love.graphics.print(
                "PELIGRO: TEMPERATURA CRITICA",
                700,
                500
            )
        end

        if reactor.pressure >= 80 and warningVisible then

            love.graphics.setColor(1, 0, 0)

            love.graphics.print(
                "PELIGRO: PRESION CRITICA",
                700,
                540
            )
        end

        if reactor.energy <= 20 and warningVisible then

            love.graphics.setColor(1, 0, 0)

            love.graphics.print(
                "PELIGRO: ENERGIA BAJA",
                700,
                580
            )
        end

        -- Current event

        if events.currentEvent then

            love.graphics.setColor(1, 0, 0)

            love.graphics.print(
                "EVENTO ACTIVO:",
                850,
                120
            )

            love.graphics.print(
                events.currentEvent.name,
                850,
                160
            )

            local eventDescription = ""

            if events.currentEvent.name ==
            "FUGA DE VAPOR" then

                eventDescription =
                "REDUCE LA PRESION"

            elseif events.currentEvent.name ==
            "FALLA DE ENFRIAMIENTO" then

                eventDescription =
                "AUMENTA EL ENFRIAMIENTO"

            elseif events.currentEvent.name ==
            "SOBRECARGA ELECTRICA" then

                eventDescription =
                "REDUCE EL CONSUMO DE ENERGIA"
            end

            love.graphics.print(
                eventDescription,
                850,
                200
            )
        end

    end

    -- GAME OVER

    if reactor.meltdown then

        love.graphics.setColor(0.5, 0, 0, 0.7)

        love.graphics.rectangle(
            "fill",
            0,
            0,
            1280,
            720
        )

        love.graphics.setColor(1, 0, 0)

        love.graphics.printf(
            "MELTDOWN DETECTADO",
            0,
            260,
            1280,
            "center"
        )

        love.graphics.printf(
            "REACTOR FUERA DE CONTROL",
            0,
            320,
            1280,
            "center"
        )

        love.graphics.printf(
            "PRESIONA R PARA REINICIAR",
            0,
            420,
            1280,
            "center"
        )
    end

    -- VICTORY

    if extraction.completed then

        love.graphics.setColor(0, 0.3, 0, 0.7)

        love.graphics.rectangle(
            "fill",
            0,
            0,
            1280,
            720
        )

        love.graphics.setColor(0, 1, 0)

        love.graphics.printf(
            "EXTRACCION COMPLETADA",
            0,
            260,
            1280,
            "center"
        )

        love.graphics.printf(
            "PERSONAL EVACUADO",
            0,
            320,
            1280,
            "center"
        )

    end

end

return ui