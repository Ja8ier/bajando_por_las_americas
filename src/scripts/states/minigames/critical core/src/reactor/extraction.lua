local extraction = {}

extraction.timeLeft = 60
extraction.completed = false

function extraction.load()

    extraction.timeLeft = 60
    extraction.completed = false
end

function extraction.update(dt)

    if not extraction.completed then

        extraction.timeLeft =
            extraction.timeLeft - dt

        if extraction.timeLeft <= 0 then

            extraction.timeLeft = 0
            extraction.completed = true
        end
    end
end

function extraction.getFormattedTime()

    local minutes =
        math.floor(extraction.timeLeft / 60)

    local seconds =
        math.floor(extraction.timeLeft % 60)

    return string.format(
        "%02d:%02d",
        minutes,
        seconds
    )
end

return extraction