local reactor = {}

reactor.meltdown = false

reactor.temperature = 45
reactor.pressure = 30
reactor.energy = 100
reactor.stability = 100
reactor.radiation = 10

reactor.coolingLevel = 1
reactor.ventilationLevel = 1

function reactor.load()
    reactor.temperature = 45
    reactor.pressure = 30
    reactor.energy = 100
    reactor.stability = 100
    reactor.radiation = 10

    reactor.coolingLevel = 1
    reactor.ventilationLevel = 1

    reactor.meltdown = false
end

function reactor.update(dt)
    -- 1. Comportamiento base del reactor
    reactor.temperature = reactor.temperature + 6 * dt
    reactor.pressure = reactor.pressure + 4 * dt

    -- Efecto de enfriamiento
    reactor.temperature = reactor.temperature - reactor.coolingLevel * 8 * dt

    -- Efecto de ventilación
    reactor.pressure = reactor.pressure - reactor.ventilationLevel * 6 * dt

    -- Consumo de energía (Submódulos activos consumen de la red eléctrica)
    reactor.energy = reactor.energy - (reactor.coolingLevel + reactor.ventilationLevel) * 1 * dt

    -- 2. LÓGICA DE ESTABILIDAD (INTERACCIÓN DINÁMICA)
    local structuralStress = false

    -- Si la temperatura es crítica (ej. > 80), drena estabilidad
    if reactor.temperature >= 80 then
        -- Cae más rápido cuanto más cerca esté del 100%
        local severity = (reactor.temperature - 80) / 20
        reactor.stability = reactor.stability - (2 * severity + 1) * dt
        structuralStress = true
    end

    -- Si la presión es crítica (ej. > 80), drena estabilidad
    if reactor.pressure >= 80 then
        local severity = (reactor.pressure - 80) / 20
        reactor.stability = reactor.stability - (2 * severity + 1) * dt
        structuralStress = true
    end

    -- Si la energía se agota por completo (Corte total de contención electromagnética)
    if reactor.energy <= 0 then
        -- La estabilidad cae en picada de forma violenta
        reactor.stability = reactor.stability - 12 * dt
        structuralStress = true
    end

    -- OPCIONAL: Si todo está bajo control (Temp y Presión < 50), reparar muy lentamente la estructura
    if not structuralStress and reactor.temperature < 50 and reactor.pressure < 50 and reactor.energy > 20 then
        reactor.stability = math.min(100, reactor.stability + 0.5 * dt)
    end

    -- 3. Delimitar valores (Clamping)
    reactor.temperature = math.max(0, math.min(100, reactor.temperature))
    reactor.pressure = math.max(0, math.min(100, reactor.pressure))
    reactor.energy = math.max(0, math.min(100, reactor.energy))
    reactor.stability = math.max(0, math.min(100, reactor.stability))

    -- 4. Nueva condición única de destrucción / Meltdown
    if reactor.stability <= 0 then
        reactor.meltdown = true
    end
end

function reactor.draw()
    -- Se mantiene vacío como lo tenías
end

function reactor.increaseCooling()
    reactor.coolingLevel = math.min(5, reactor.coolingLevel + 1)
end

function reactor.decreaseCooling()
    reactor.coolingLevel = math.max(0, reactor.coolingLevel - 1)
end

function reactor.increaseVentilation()
    reactor.ventilationLevel = math.min(5, reactor.ventilationLevel + 1)
end

function reactor.decreaseVentilation()
    reactor.ventilationLevel = math.max(0, reactor.ventilationLevel - 1)
end

return reactor