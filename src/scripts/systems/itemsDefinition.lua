ITEM_TYPES = {
    WEAPON = "weapon",
    CONSUMIBLE = "consumible",
    CARRYABLE_OBJECT = "carryableObject",
    KEY_EVENT = "keyEvent"
}
local scale = love.graphics.getWidth() / 256

local itemDefinitions = {

    bottle = {
        name = "Pico de botella",
        texture = "",
        type = ITEM_TYPES.WEAPON,
        isStackable = false,
        count = 1,
        haswear = true,
        levelOfWear = 10,
        onUse = function()
            --atack
        end,
        scale = scale * 1
    },

    knife = {
        name = "Cuchillo",
        texture = love.graphics.newImage("assets/sprites/items/knife.png"),
        type = ITEM_TYPES.WEAPON,
        isStackable = false,
        count = 1,
        haswear = true,
        levelOfWear = 10,
        onUse = function()
            --atack
        end,
        scale = scale * 0.5
    },

    bat = {
        name = "Bate de baseball",
        texture = "",
        type = ITEM_TYPES.WEAPON,
        isStackable = false,
        count = 1,
        haswear = true,
        levelOfWear = 10,
        onUse = function()
            --atack
        end,
        scale = scale * 1
    },

    wrench = {
        name = "Llave inglesa",
        texture = "",
        type = ITEM_TYPES.WEAPON,
        isStackable = false,
        count = 1,
        haswear = true,
        levelOfWear = 10,
        onUse = function()
            --atack
        end,
        scale = scale * 1
    },

    stones = {
        name = "Piedras",
        texture = "",
        type = ITEM_TYPES.WEAPON,
        isStackable = true,
        count = 5,
        haswear = false,
        levelOfWear = 0,
        onUse = function()
            --throw
        end,
        scale = scale * 1
    },

    heavyStone = {
        name = "Piedra",
        texture = "",
        type = ITEM_TYPES.CARRYABLE_OBJECT,
        isStackable = false,
        count = 1,
        haswear = false,
        levelOfWear = 0,
        onUse = function()
            --pick up
        end,
        scale = scale * 1
    },

    paperKey = {
        name = "Código",
        texture = "",
        type = ITEM_TYPES.KEY_EVENT,
        isStackable = false,
        count = 1,
        haswear = false,
        levelOfWear = 0,
        onUse = function()
            --ver codigo
        end,
        scale = scale * 1
    },


}

-- ITEM_TYPES = {
--     WEAPON = "weapon",
--     CONSUMIBLE = "consumible",
--     CARRYABLE_OBJECT = "carryableObject",
--     KEY_EVENT = "keyEvent"
-- }

return itemDefinitions