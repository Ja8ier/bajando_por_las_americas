local hud = {}

function hud.drawTimer(timer, timerFont)
    love.graphics.setFont(timerFont)

    if timer <= 10 then
        love.graphics.setColor(1, 0, 0)
    else
        love.graphics.setColor(1, 1, 1)
    end

    love.graphics.printf(tostring(math.ceil(timer)), 0, 60, love.graphics.getWidth(), "center")
end

function hud.drawInstruction(gameplayPhase, currentMode, currentInstruction, targetButton, font)
    if gameplayPhase ~= "main" then return end

    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1)

    if currentMode == "wire" then
        local translatedColor = ""
        if currentInstruction == "red" then translatedColor = "ROJO"
        elseif currentInstruction == "blue" then translatedColor = "AZUL"
        elseif currentInstruction == "green" then translatedColor = "VERDE"
        elseif currentInstruction == "yellow" then translatedColor = "AMARILLO"
        end

        love.graphics.printf("CORTA EL CABLE " .. translatedColor, 0, 180, love.graphics.getWidth(), "center")
    else
        love.graphics.printf("PRESIONA EL BOTON " .. tostring(targetButton), 0, 180, love.graphics.getWidth(), "center")
    end
end

function hud.drawStartScreen(titleFont, font, showPress)
    love.graphics.setFont(titleFont)
    love.graphics.setColor(1, 0.2, 0.2)
    love.graphics.printf("DESACTIVA LA BOMBA", 0, 180, love.graphics.getWidth(), "center")

    if showPress then
        love.graphics.setFont(font)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("PRESIONA ENTER PARA INICIAR", 0, 420, love.graphics.getWidth(), "center")
    end
end

function hud.drawWinScreen(titleFont)
    love.graphics.setFont(titleFont)
    love.graphics.setColor(0, 1, 0)
    love.graphics.printf("BOMBA DESACTIVADA", 0, 260, love.graphics.getWidth(), "center")
end

function hud.drawFailScreen(titleFont, font)
    love.graphics.setFont(titleFont)
    love.graphics.setColor(1, 0, 0)
    love.graphics.printf("BOOM", 0, 240, love.graphics.getWidth(), "center")

    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("PRESIONA R PARA REINICIAR", 0, 340, love.graphics.getWidth(), "center")
end

return hud