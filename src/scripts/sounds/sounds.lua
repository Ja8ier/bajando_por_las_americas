local sounds = {
    background_music = {},

    sound_effects = {
        pasos = love.audio.newSource("assets/sounds/walk_sound.mp3", "static"),
        pasos2 = love.audio.newSource("assets/sounds/walking2.mp3", "static")
    },

    cutscene_sounds = {}
}

return sounds