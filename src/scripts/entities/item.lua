local item = {}

item.TYPES = {
    WEAPON = "weapon",
    CONSUMIBLE = "consumible",
    KEY_EVENT = "keyEvent"
}

function item.new(_id, _nameToShow, _texture, _type , _isStackable, _count, _hasWear, _levelOfWear, _onUse)

    if not _isStackable then
        _count = 0
    end

    if not _hasWear then
        _levelOfWear = 0
    end

    local item = {
        id = _id,
        type = _type,
        nameToShow = _nameToShow,
        texture = _texture,
        isStackable = _isStackable,
        count = _count,
        hasWear = _hasWear,
        levelOfWear = _levelOfWear,
        onUse = _onUse
    }

    item.texture:setFilter("nearest", "nearest")

    return item
end

return item