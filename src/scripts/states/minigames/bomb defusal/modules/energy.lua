local energy = {}

-- PANEL
energy.panel = nil
energy.panelX = 120
energy.panelY = 250
energy.panelScale = 0.55

-- CURSOR
energy.cursor = 0
energy.direction = 1
energy.speed = 520

-- BAR
energy.bar = { x = 0, y = 0, w = 0, h = 0 }

-- SUCCESS ZONE
energy.successZone = { x = 0, w = 0 }

function energy.load()
    energy.panel = love.graphics.newImage("assets/images/energy_panel.png")

    -- IMPORTANT:
    -- NO TOCAR ESTOS OFFSETS
    -- YA ESTÁN PERFECTAMENTE ALINEADOS
    energy.bar.x = energy.panelX + (450 * energy.panelScale)
    energy.bar.y = energy.panelY + (220 * energy.panelScale)
    energy.bar.w = 1080 * energy.panelScale
    energy.bar.h = 70 * energy.panelScale

    energy.successZone.x = energy.bar.x + (720 * energy.panelScale)
    energy.successZone.w = 310 * energy.panelScale
end

function energy.update(dt)
    energy.cursor = energy.cursor + energy.direction * energy.speed * dt

    if energy.cursor <= 0 then
        energy.cursor = 0
        energy.direction = 1
    end

    if energy.cursor >= energy.bar.w then
        energy.cursor = energy.bar.w
        energy.direction = -1
    end
end

function energy.draw(font)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(energy.panel, energy.panelX, energy.panelY, 0, energy.panelScale, energy.panelScale)

    -- SUCCESS ZONE
    love.graphics.setColor(0, 1, 0, 0.35)
    love.graphics.rectangle("fill", energy.successZone.x, energy.bar.y, energy.successZone.w, energy.bar.h)

    -- CURSOR
    local cursorX = energy.bar.x + energy.cursor
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", cursorX - 5, energy.bar.y - 10, 10, energy.bar.h + 20)

    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("PRESIONA ESPACIO CUANDO EL CURSOR ESTE DENTRO DE LA ZONA VERDE", 0, 180, love.graphics.getWidth(), "center")
end

function energy.checkSuccess()
    local cursorX = energy.bar.x + energy.cursor
    return (cursorX >= energy.successZone.x and cursorX <= energy.successZone.x + energy.successZone.w)
end

function energy.reset()
    energy.cursor = 0
    energy.direction = 1
end

return energy