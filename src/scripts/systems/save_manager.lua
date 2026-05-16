local json = require("src.libraries.dkjson")

local SaveManager = {}

-- Función interna para generar el nombre del archivo basado en el nombre del jugador
local function getSaveFileName(playerName)
    if playerName and playerName ~= "" then
        -- Reemplaza espacios por guiones bajos para evitar problemas en rutas
        local safeName = playerName:gsub("%s+", "_")
        return "save_" .. safeName .. ".json"
    end
    return "save_default.json" -- Por si acaso
end

-- Ahora recibe el GameState completo
function SaveManager.save(data)
    -- Obtenemos el nombre dinámico usando el nombre guardado en el GameState
    local filename = getSaveFileName(data.player and data.player.name)
    
    local serialized = json.encode(data, { indent = true })
    love.filesystem.write(filename, serialized)
end

-- Ahora recibe el nombre de la partida que queremos cargar
function SaveManager.load(playerName)
    local filename = getSaveFileName(playerName)

    if not love.filesystem.getInfo(filename) then
        return nil
    end

    local contents = love.filesystem.read(filename)
    local data = json.decode(contents)

    return data

end

return SaveManager