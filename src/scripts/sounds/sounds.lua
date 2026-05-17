local sounds = {
    background_music = {},

    sound_effects = {
        walk = love.audio.newSource("assets/sounds/walking.wav", "static"),
        run = love.audio.newSource("assets/sounds/running.wav", "static")
    },

    cutscene_sounds = {}
}

-- FUNCIÓN NUEVA: Actualiza el volumen general según el interruptor de Ajustes
function sounds.update()
    -- Si Audio es true, volumen al máximo (1), si es false, mutear (0)
    local master_volume = Audio and 1 or 0
    love.audio.setVolume(master_volume)
end

-- FUNCIÓN NUEVA: Reproduce un sonido de forma segura (reiniciándolo si ya suena)
function sounds.play(source)
    if source then
        source:seek(0)
        source:play()
    end
end

-- FUNCIÓN NUEVA: Detiene un sonido en específico
function sounds.stop(source)
    if source then
        source:stop()
    end
end

return sounds