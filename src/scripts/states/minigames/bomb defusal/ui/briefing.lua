local Briefing = {}

local briefingText = [[
ADVERTENCIA

Dispositivo explosivo detectado.

Protocolo:
- Corta el cable correcto
- Presiona el boton correcto
- Estabiliza el nucleo de energia
- Introduce el codigo de seguridad
- Presiona el boton final en el ultimo segundo

El fallo provocara detonacion.
]]

local displayedText = ""
local typingIndex = 0
local typingTimer = 0
local typingSpeed = 0.005
local finished = false
local blinkTimer = 0
local showPress = true

function Briefing.reset()
    displayedText = ""
    typingIndex = 0
    typingTimer = 0
    finished = false
end

function Briefing.update(dt)
    -- TYPEWRITER
    if not finished then
        typingTimer = typingTimer + dt

        if typingTimer >= typingSpeed then
            typingTimer = 0
            typingIndex = typingIndex + 1

            if typingIndex > #briefingText then
                typingIndex = #briefingText
                finished = true
            end

            displayedText = string.sub(briefingText, 1, typingIndex)
        end
    end

    -- BLINK
    blinkTimer = blinkTimer + dt
    if blinkTimer >= 0.5 then
        blinkTimer = 0
        showPress = not showPress
    end
end

function Briefing.draw(font)
    -- BACKGROUND
    love.graphics.setColor(0, 0, 0, 0.82)
    love.graphics.rectangle("fill", 120, 80, 760, 560)

    -- BORDER
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("line", 120, 80, 760, 560)

    -- TEXT
    love.graphics.setFont(font)
    love.graphics.setColor(0, 1, 0)
    love.graphics.printf(displayedText, 160, 130, 680, "left")

    -- CONTINUE
    if finished and showPress then
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("PRESIONA ENTER PARA CONTINUAR", 0, 590, love.graphics.getWidth(), "center")
    end
end

function Briefing.isFinished()
    return finished
end

return Briefing