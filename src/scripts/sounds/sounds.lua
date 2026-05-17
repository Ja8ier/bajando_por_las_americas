local sounds = {
    background_music = {
        -- Cargamos la música como stream (ideal para canciones largas)
        ambient = love.audio.newSource("assets/sounds/ambientMusic.wav", "stream")
    },

    sound_effects = {
        walk = love.audio.newSource("assets/sounds/walking.wav", "static"),
        run = love.audio.newSource("assets/sounds/running.wav", "static")
    },

    cutscene_sounds = {}
}

-- Función para inicializar propiedades por defecto
function sounds.init()
    if sounds.background_music.ambient then
        -- Hacemos que la música de fondo se repita infinitamente
        sounds.background_music.ambient:setLooping(true)
    end
    -- Sincronizamos con el estado de la variable global 'Audio'
    sounds.update()
end

-- Actualiza el volumen general según el interruptor de Ajustes (On/Off)
function sounds.update()
    -- Red de seguridad: Si Audio es nil (no existe), usamos 'true' por defecto
    if Audio == nil then
        Audio = true
    end

    -- Si Audio es true, volumen al máximo (1), si es false, mutear (0)
    local master_volume = Audio and 1 or 0
    love.audio.setVolume(master_volume)
end

-- Funciones para controlar la música ambiental
function sounds.playAmbient()
    if sounds.background_music.ambient then
        sounds.background_music.ambient:play()
    end
end

function sounds.stopAmbient()
    if sounds.background_music.ambient then
        sounds.background_music.ambient:stop()
    end
end

-- Reproduce un efecto de sonido de forma segura (reiniciándolo si ya suena)
function sounds.play(source)
    if source then
        source:seek(0)
        source:play()
    end
end

-- Detiene un sonido en específico
function sounds.stop(source)
    if source then
        source:stop()
    end
end

return sounds