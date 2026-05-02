local inputs = {

    menu = {
        newGame = "return", --enter
        continueGame = "space",
        settings = "s",
        exit = "esc"
    },

    createNewGame = {
        back = "esc"
    },

    continueGame = {
        back = "esc"
    },

    settings = {
        back = "esc"
    },

    game = {
        pause = {"esc", "p"},
        up = "w",
        down = "s",
        left = "a",
        right = "d",
        sprint = "shift",
        crouch = "c", --agacharse
        attack = "k",
        openInventory = "e",
        dropItem = "r",
        pickUpItem = "f",
       -- slide = "j"
    }

}

return inputs