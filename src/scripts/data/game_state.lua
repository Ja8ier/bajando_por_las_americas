local GameState = {

    currentStage = 1,

    player = {
        name = "",
        lives = 3,
        health = 10000,
        maxHealth = 10000,
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