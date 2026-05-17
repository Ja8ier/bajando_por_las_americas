local utf8 = require("utf8")
local audio = require("src.scripts.states.minigames.critical core.src.audio.audio")
local inputs = require("src.scripts.utils.inputs")

local briefing = {}

local text = [[
INICIALIZANDO PROTOCOLO DE EMERGENCIA...

FALLA CRITICA DETECTADA EN EL NUCLEO
SISTEMA DE REFRIGERACION FUERA DE SERVICIO
NIVELES DE RADIACION EN AUMENTO

EVACUACION AUTOMATICA EN PROCESO

-TIEMPO ESTIMADO DE EXTRACCION:
01:00

-OBJETIVO:
MANTENER LA ESTABILIDAD DEL REACTOR
HASTA LA LLEGADA DE LA EXTRACCION
ESTO LO LOGRARAS MANTENIENDO LOS NIVELES DE
ENFRIAMIENTO Y VENTILACION

-ADVERTENCIA:
SI LA ESTABILIDAD DEL NUCLEO
ALCANZA NIVELES CRÍTICOS,

SE PRODUCIRA UNA FUSION TOTAL...
BUENA SUERTE...
]]

local displayedText = ""

local charIndex = 1
local textLength = utf8.len(text)

local typingSpeed = 0.005
local timer = 0

local font

local showCursor = true
local cursorTimer = 0

local showStartText = true
local startTextTimer = 0

local textFinished = false

function briefing.load()

    love.graphics.setBackgroundColor(0, 0, 0)

    font = love.graphics.newFont(
        "assets/fonts/terminal.ttf",
        12
    )
end

function briefing.update(dt)

    -- Cursor blinking
    cursorTimer = cursorTimer + dt

    if cursorTimer >= 0.5 then
        showCursor = not showCursor
        cursorTimer = 0
    end

    -- Start text blinking
    startTextTimer = startTextTimer + dt

    if startTextTimer >= 0.6 then
        showStartText = not showStartText
        startTextTimer = 0
    end

    -- Typing effect
    if not textFinished then

        timer = timer + dt

        if timer >= typingSpeed then

            local byteStart = utf8.offset(text, charIndex)
            local byteEnd = utf8.offset(text, charIndex + 1)

            if byteStart then

                local character

                if byteEnd then
                    character = text:sub(byteStart, byteEnd - 1)
                else
                    character = text:sub(byteStart)
                end

                displayedText = displayedText .. character

                if charIndex % 2 == 0 then
                    audio.play("type")
                end
            end

            charIndex = charIndex + 1

            timer = 0

            if charIndex > textLength then
                textFinished = true
            end
        end
    end
end

function briefing.draw()

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setFont(font)

    -- Green terminal color
    love.graphics.setColor(0, 1, 0)

    love.graphics.printf(
        displayedText,
        100,
        100,
        1080
    )

    -- Blinking cursor
    if showCursor then

        local cursorText = "_"

        love.graphics.print(
            cursorText,
            100 + font:getWidth(displayedText) % 1080,
            100 + math.floor(font:getWidth(displayedText) / 1080) * 32
        )
    end

    -- Start message
    if textFinished and showStartText then

        love.graphics.printf(
            "PRESIONA ENTER PARA COMENZAR",
            0,
            620,
            1280,
            "center"
        )
    end

    love.graphics.print("Presione ESPACIO para SKIP", love.graphics.getWidth() - 420, love.graphics.getHeight() - 30)
end

function briefing.keypressed(key)

    -- Skip typing
    if key == inputs.minigames["3"].skip and not textFinished then
        displayedText = text
        charIndex = textLength + 1
        textFinished = true
    end

    -- Start game
    if key == inputs.minigames["3"].start and textFinished then
        local stateManager = require("src.scripts.states.minigames.critical core.src.core.stateManager")
        stateManager.setState("PLAYING")
    end
end

function briefing.reset()
    displayedText = ""
    charIndex = 1
    timer = 0
    cursorTimer = 0
    startTextTimer = 0
    textFinished = false
end

return briefing