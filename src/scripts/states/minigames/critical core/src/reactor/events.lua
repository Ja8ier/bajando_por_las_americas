local Queue = require("src.scripts.states.minigames.critical core.src.utils.queue")

local events = {}

events.queue = Queue.new()

events.currentEvent = nil

events.timer = 0
events.eventInterval = 15

function events.load()

    events.queue = Queue.new()

    events.currentEvent = nil

    events.timer = 0
end

function events.update(dt, reactor)

    -- Generate events
    events.timer = events.timer + dt

    if events.timer >= events.eventInterval then

        events.generateRandomEvent()

        events.timer = 0
    end

    -- Process current event
    if not events.currentEvent
    and not events.queue:isEmpty() then

        events.currentEvent =
            events.queue:dequeue()

        events.currentEvent.active = true
    end

    -- Update active event
    if events.currentEvent then

        events.currentEvent.duration =
            events.currentEvent.duration - dt

        events.applyEventEffect(
            events.currentEvent,
            reactor,
            dt
        )

        if events.currentEvent.duration <= 0 then

            events.currentEvent = nil
        end
    end
end

function events.generateRandomEvent()

    local randomType =
        love.math.random(1, 3)

    local event

    if randomType == 1 then

        event = {
            name = "FUGA DE VAPOR",
            duration = 8
        }

    elseif randomType == 2 then

        event = {
            name = "FALLA DE ENFRIAMIENTO",
            duration = 10
        }

    elseif randomType == 3 then

        event = {
            name = "SOBRECARGA ELECTRICA",
            duration = 7
        }
    end

    events.queue:enqueue(event)

    local audio =
        require("src.scripts.states.minigames.critical core.src.audio.audio")

    audio.play("event")
end

function events.applyEventEffect(event, reactor, dt)

    if event.name == "FUGA DE VAPOR" then

        reactor.pressure =
            reactor.pressure + 8 * dt
    end

    if event.name == "FALLA DE ENFRIAMIENTO" then

        reactor.temperature =
            reactor.temperature + 6 * dt
    end

    if event.name == "SOBRECARGA ELECTRICA" then

        reactor.energy =
            reactor.energy - 2 * dt
    end
end

return events