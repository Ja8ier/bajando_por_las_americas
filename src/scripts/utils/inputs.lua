local inputs = {

    menu = {
        newGame = "return", --enter
        continueGame = "space",
        settings = "s",
        exit = "escape"
    },

    createNewGame = {
        back = "escape"
    },

    continueGame = {
        back = "escape"
    },

    settings = {
        back = "escape"
    },

    game = {
        pause = {"escape", "p"},
        up = "w",
        down = "s",
        left = "a",
        right = "d",
        sprint = "lshift",
        crouch = "c", --agacharse
        attack = "k",
        kick = "j",
        interact = "tab",
        openInventory = "e",
        useItem = "i",
        dropItem = "r",
        pickUpItem = "f",
        slots = {
            [1] = "1",
            [2] = "2",
            [3] = "3",
            [4] = "4",
            [5] = "5",
            [6] = "6",
            [7] = "7",
            [8] = "8",
            [9] = "9",
        },

    },

    minigames = {

        ["1"] = {
            up = "up",
            down = "down",
            left = "left",
            right = "right",
            continue = "return",
            restart = "r",
            quit = "lctrl"
        },

    }

}

return inputs