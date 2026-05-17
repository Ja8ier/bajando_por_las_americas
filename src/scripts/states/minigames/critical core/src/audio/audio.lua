local audio = {}

audio.sounds = {}

function audio.load()

    audio.sounds.hum =
        love.audio.newSource(
            "assets/sounds/minigames/criticalCore/hum.wav",
            "stream"
        )

    audio.sounds.alarm =
        love.audio.newSource(
            "assets/sounds/minigames/criticalCore/alarm.mp3",
            "stream"
        )

    audio.sounds.beep =
        love.audio.newSource(
            "assets/sounds/minigames/criticalCore/beep.wav",
            "static"
        )

    audio.sounds.event =
        love.audio.newSource(
            "assets/sounds/minigames/criticalCore/event.wav",
            "static"
        )

    audio.sounds.type =
        love.audio.newSource(
            "assets/sounds/minigames/criticalCore/type.wav",
            "static"
        )
    audio.sounds.type:setVolume(0.12)

    -- Reactor hum setup
    audio.sounds.hum:setLooping(true)
    audio.sounds.hum:setVolume(0.4)

    -- Alarm setup
    audio.sounds.alarm:setLooping(true)
    audio.sounds.alarm:setVolume(0.5)
end

function audio.play(soundName)

    if audio.sounds[soundName] then

        audio.sounds[soundName]:stop()
        audio.sounds[soundName]:play()
    end
end

return audio