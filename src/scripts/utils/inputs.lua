local inputs = {

    menu = {
        newGame = "return", --enter
        continueGame = "space",
        settings = "s",
        exit = "escape"
    },

    createNewGame = {
        back = "escape",
        create = "return"
    },

    continueGame = {
        back = "escape"
    },

    settings = {
        back = "escape"
    },

    game = {
        pause = {"escape", "p"},
        nextLevel = "space",
        up = "w",
        down = "s",
        left = "a",
        right = "d",
        sprint = "lshift",
        crouch = "c", --agacharse
        interact = "tab",
        useItem = "j",
        attack = "k",
        carryObject = "l",
        dropItem = "q",
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