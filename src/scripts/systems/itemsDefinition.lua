ITEM_TYPES = {
    WEAPON = "weapon",
    CONSUMIBLE = "consumible",
    CARRYABLE_OBJECT = "carryableObject",
    KEY_EVENT = "keyEvent"
}
local scale = love.graphics.getWidth() / 256

local itemDefinitions = {

    bottle = {
        id = "bottle",
        name = "Pico de botella",
        texture = love.graphics.newImage("assets/sprites/items/bottle.png"),
        itemType = ITEM_TYPES.WEAPON,
        isStackable = false,
        count = 1,
        hasWear = true,
        levelOfWear = 320,
        onUse = function()
            --atack
        end,
        scale = scale * 0.25
    },

    knife = {
        id = "knife",
        name = "Cuchillo",
        texture = love.graphics.newImage("assets/sprites/items/knife.png"),
        itemType = "weapon",
        isStackable = false,
        count = 1,
        hasWear = true,
        levelOfWear = 420,
        onUse = function()
            --atack
        end,
        scale = scale * 0.25
    },

    bat = {
        id = "bat",
        name = "Bate de beisbol",
        texture = love.graphics.newImage("assets/sprites/items/baseballBat.png"),
        itemType = ITEM_TYPES.WEAPON,
        isStackable = false,
        count = 1,
        hasWear = true,
        levelOfWear = 480,
        onUse = function()
            --atack
        end,
        scale = scale * 0.25
    },

    wrench = {
        id = "wrench",
        name = "Llave inglesa",
        texture = love.graphics.newImage("assets/sprites/items/wrench.png"),
        itemType = ITEM_TYPES.WEAPON,
        isStackable = false,
        count = 1,
        hasWear = true,
        levelOfWear = 500,
        onUse = function()
            --atack
        end,
        scale = scale * 0.25
    },

    stones = {
        id = "stones",
        name = "Piedras",
        texture = love.graphics.newImage("assets/sprites/items/knife.png"),
        itemType = ITEM_TYPES.WEAPON,
        isStackable = true,
        count = 5,
        hasWear = false,
        levelOfWear = 0,
        onUse = function()
            --throw
        end,
        scale = scale * 1
    },

    heavyStone = {
        id = "heavyStone",
        name = "Piedra",
        texture = love.graphics.newImage("assets/sprites/items/knife.png"),
        itemType = ITEM_TYPES.CARRYABLE_OBJECT,
        isStackable = false,
        count = 1,
        hasWear = false,
        levelOfWear = 0,
        onUse = function()
            --pick up
        end,
        scale = scale * 1
    },

    paperKey = {
        id = "paperKey",
        name = "Código",
        texture = love.graphics.newImage("assets/sprites/items/knife.png"),
        itemType = ITEM_TYPES.KEY_EVENT,
        isStackable = false,
        count = 1,
        hasWear = false,
        levelOfWear = 0,
        onUse = function()
            --ver codigo
        end,
        scale = scale * 1
    },

}


return itemDefinitions