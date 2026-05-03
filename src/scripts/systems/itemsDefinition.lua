ITEM_TYPES = {
    WEAPON = "weapon",
    CONSUMIBLE = "consumible",
    CARRYABLE_OBJECT = "carryableObject",
    KEY_EVENT = "keyEvent"
}

local itemDefinitions = {

    brokeBottle = {
        name = "Pico de botella",
        texture = "",
        type = ITEM_TYPES.WEAPON,
        isStackable = false,
        count = 1,
        haswear = true,
        levelOfWear = 10,
        onUse = function()
            --atack
        end
    },

    knife = {
        name = "Cuchillo",
        texture = "",
        type = ITEM_TYPES.WEAPON,
        isStackable = false,
        count = 1,
        haswear = true,
        levelOfWear = 10,
        onUse = function()
            --atack
        end
    },

    baseballBat = {
        name = "Bate de baseball",
        texture = "",
        type = ITEM_TYPES.WEAPON,
        isStackable = false,
        count = 1,
        haswear = true,
        levelOfWear = 10,
        onUse = function()
            --atack
        end
    },

    ironBar = {
        name = "Palanca de hierro",
        texture = "",
        type = ITEM_TYPES.WEAPON,
        isStackable = false,
        count = 1,
        haswear = true,
        levelOfWear = 10,
        onUse = function()
            --atack
        end
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
        end
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
        end
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
        end
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
        end
    },

    disco = {
        name = "disco easter egg",
        texture = love.graphics.newImage("assets/sprites/items/testItem.png"),
        type = ITEM_TYPES.WEAPON,
        isStackable = false,
        count = 1,
        haswear = true,
        levelOfWear = 10,
        onUse = function()
            -- body
        end
    }

}

-- ITEM_TYPES = {
--     WEAPON = "weapon",
--     CONSUMIBLE = "consumible",
--     CARRYABLE_OBJECT = "carryableObject",
--     KEY_EVENT = "keyEvent"
-- }

return itemDefinitions