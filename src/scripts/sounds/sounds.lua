local sounds = {
    background_music = {
        ambient = love.audio.newSource("assets/sounds/ambientMusic.wav", "stream")
    },

    sound_effects = {
        walk = love.audio.newSource("assets/sounds/walkingDefinitive.mp3", "static"),
        run = love.audio.newSource("assets/sounds/runningDefinitive.mp3", "static"),
        hit = love.audio.newSource("assets/sounds/golpesound.mpeg", "static"),
        swish = love.audio.newSource("assets/sounds/swish.wav", "static")
    },

    cutscene_sounds = {}
}

function sounds.init()
    if sounds.background_music.ambient then
        sounds.background_music.ambient:setLooping(true)
    end
    
    if sounds.sound_effects.walk then
        sounds.sound_effects.walk:setLooping(true)
    end

    if sounds.sound_effects.run then
        sounds.sound_effects.run:setLooping(true)
    end

    -- Aplicamos los volúmenes específicos desde el inicio
    sounds.update()
end

--Volúmenes independientes por cada tipo de sonido
function sounds.update()
    if Audio == nil then
        Audio = true
    end

    if Audio then
        --Dejamos el volumen general del motor al máximo
        love.audio.setVolume(1)
        
        
        if sounds.background_music.ambient then
            sounds.background_music.ambient:setVolume(0.03) -- Música de fondo muy suave
        end
        if sounds.sound_effects.walk then
            sounds.sound_effects.walk:setVolume(1)    
        end
        if sounds.sound_effects.run then
            sounds.sound_effects.run:setVolume(1)
        end
        if sounds.sound_effects.hit then
            sounds.sound_effects.hit:setVolume(0.2)
        end
    else
        -- Si el jugador pulsa "Mute" en Ajustes, silenciamos el volumen general por completo
        love.audio.setVolume(0)
    end
end

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

function sounds.startWalking()
    if sounds.sound_effects.walk then
        sounds.sound_effects.walk:play()
    end
end

function sounds.stopWalking()
    if sounds.sound_effects.walk then
        sounds.sound_effects.walk:stop()
    end
end

--Funciones para controlar los pasos al correr
function sounds.startRunning()
    if sounds.sound_effects.run then
        sounds.sound_effects.run:play()
    end
end

function sounds.stopRunning()
    if sounds.sound_effects.run then
        sounds.sound_effects.run:stop()
    end
end

function sounds.play(source)
    if source then
        source:seek(0)
        source:play()
    end
end

function sounds.stop(source)
    if source then
        source:stop()
    end
end

return sounds