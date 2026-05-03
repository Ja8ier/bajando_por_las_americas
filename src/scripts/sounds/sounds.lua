local sounds = {
    background_music = {},

    sound_effects = {
        walk = love.audio.newSource("assets/sounds/walking.wav", "static"),
        run = love.audio.newSource("assets/sounds/running.wav", "static")
    },

    cutscene_sounds = {}
}

return sounds