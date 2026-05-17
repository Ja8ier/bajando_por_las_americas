local GameState = {

    currentStage = 1,

    player = {
        name = "",
        lives = 3,
        health = 15000,
        maxHealth = 15000,
        attempts = 3,
        x = 0,
        y = 0
    },

    stats = {
        enemiesDefeated = 0,
        deaths = 0
    },

    world = {
        usedTriggers = {},

        savedEnemies = {}
    }
}

return GameState