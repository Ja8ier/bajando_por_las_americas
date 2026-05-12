local json = require("src.libraries.dkjson")

local SaveManager = {}

local SAVE_FILE = "save.json"

function SaveManager.save(data)

    local serialized = json.encode(data, { indent = true })

    love.filesystem.write(SAVE_FILE, serialized)

end

function SaveManager.load()

    if not love.filesystem.getInfo(SAVE_FILE) then
        return nil
    end

    local contents = love.filesystem.read(SAVE_FILE)

    local data = json.decode(contents)

    return data

end

return SaveManager