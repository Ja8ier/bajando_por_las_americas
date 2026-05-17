local json = require("src.libraries.dkjson")

local SaveManager = {}

function SaveManager.save(data, slot)

    local filename = "save_slot" .. slot .. ".json"

    local serialized = json.encode(data, { indent = true })

    love.filesystem.write(filename, serialized)

end

function SaveManager.load(slot)

    local filename = "save_slot" .. slot .. ".json"

    if not love.filesystem.getInfo(filename) then
        return nil
    end

    local contents = love.filesystem.read(filename)

    local data = json.decode(contents)

    return data

end

--check si slot existe
function SaveManager.exists(slot)
    local filename = "save_slot" .. slot .. ".json"
    return love.filesystem.getInfo(filename) ~= nil
end

return SaveManager