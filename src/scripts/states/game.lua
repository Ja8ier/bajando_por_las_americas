local game = {
    isPlaying = false,
    isPaused = false,
    gameOver = false
}

local stages = {}

local inputs = require("src.scripts.utils.inputs")
local gui = require("src.scripts.gui.gui")
local panel = require("src.scripts.gui.panel")
local player = require("src.scripts.entities.player")
local GameState = require("src.scripts.data.game_state")
local SaveManager = require("src.scripts.systems.save_manager")

local exitGame = panel.new((love.graphics.getWidth() - 350)/2, (love.graphics.getHeight() - 150)/2, 400, 200, "PAUSA", 30)

local currentStageIndex = 1
local currentStage = nil
local oneTime = true

local function saveCurrentGame() --funcion que convierte el gameplay actual en datos persistentes

    GameState.currentStage = currentStageIndex

    GameState.player.health = player.HP
    GameState.player.maxHealth = player.maxHP
    GameState.player.attempts = player.numberAttempts

    GameState.player.x = player.x
    GameState.player.y = player.y

    GameState.world.savedEnemies = {}

    for _, enemy in ipairs(currentStage.enemies) do --cuando se guarda recorre enemigos vivos, guarda solo datos esenciales e ignora enemigos muertos

        if not enemy.isDead then

            table.insert(GameState.world.savedEnemies, {

                id = enemy.id,

                type = enemy.enemyType,

                x = enemy.x,
                y = enemy.y,

                hp = enemy.HP

            })

        end

    end

    SaveManager.save(GameState, GameState.currentSlot)

end

function game.load()

    stages[1] = require("src.scripts.states.stage1")
    stages[2] = require("src.scripts.states.stage2")
    stages[3] = require("src.scripts.states.stage3")
    stages[4] = require("src.scripts.states.stage4")

    --carga el primer stage
    currentStage = stages[currentStageIndex]

    if currentStage and currentStage.load then
        currentStage.load()
    end

    game.isPlaying = true
    game.isPaused = false
    game.gameOver = false

end

function game.nextStage()

    currentStageIndex = currentStageIndex + 1

    if stages[currentStageIndex] then
        --carga el siguiente
        currentStage = stages[currentStageIndex]
        if currentStage.load then
            currentStage.load()
        end
    else
        --final del juego
        game.gameOver = true
        game.isPlaying = false
    end

end

function game.restoreStage()

    oneTime = true
    player.isDead = false
    player.HP = player.maxHP/2
    player.entityStatus = {statusType = "none", statusTimer = 0}

    if currentStage and currentStage.updateCheckPoint then
        currentStage.updateCheckPoint()
    end

    game.isPlaying = true
    game.gameOver = false
    game.isPaused = false

end

function game.restartStage()

    player.isDead = false
    oneTime = true
    game.isPlaying = true
    game.gameOver = false
    game.isPaused = false

    if currentStage and currentStage.cleanStatus then
        currentStage.cleanStatus()
    end

    if player and player.cleanStatus then
        player.cleanStatus()
    end

    if currentStage and currentStage.load then
        currentStage.load()
    end
end

function game.update(dt)

    if not game.isPlaying or game.gameOver then
        return
    end

    if game.isPaused then
        return
    end

    if currentStage and currentStage.update then
        currentStage.update(dt)
    end

    if player.HP <= 0 then
        if oneTime then
            player.numberAttempts = player.numberAttempts - 1
            game.isPlaying = false
            oneTime = false
        end

        if player.numberAttempts > 0 then
            player.isDead = true
        else
            game.gameOver = true
            game.isPlaying = false
        end
    end
end

function game.draw()

    if currentStage and currentStage.draw then
        currentStage.draw()
    end

    if game.isPaused then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Presiona " ..string.upper(inputs.game.pause[1]).. " o ".. string.upper(inputs.game.pause[2]) .. " para reanudar", 10, 10)

        exitGame.visible = true
        panel.draw(exitGame)

        gui.Draw_button("Guardar y Salir", exitGame.x + (exitGame.w - 250)/2, exitGame.y + 15 + (exitGame.h - 50)/2, 250, 50, 10,
        gui.utils.Search_opacity(exitGame.x + (exitGame.w - 250)/2, exitGame.x + (exitGame.w - 250)/2 + 250,
        exitGame.y + 15 + (exitGame.h - 50)/2, exitGame.y + 65 + (exitGame.h - 50)/2, true))
    end

    if player.isDead then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("MORISTE!", (love.graphics.getWidth() - 300)/2, love.graphics.getHeight()/2 - 50, 0, 4, 4)
        love.graphics.print("Te quedan " .. player.numberAttempts .. " intentos", (love.graphics.getWidth() - 500)/2, love.graphics.getHeight()/2 + 50, 0, 2, 2)
        love.graphics.print("Presiona R para Restaurar, ESC para Guardar y Salir", 10, 10)
    end

    if game.gameOver then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("GAME OVER", (love.graphics.getWidth() - 300)/2, love.graphics.getHeight()/2, 0, 2, 2)
        love.graphics.print("Presiona R para reiniciar, ESC para salir", 10, 10)
    end
end


function game.keypressed(key)

     if (type(inputs.game.pause) == "table") and (key == inputs.game.pause[1] or key == inputs.game.pause[2]) then

        if not game.isPaused and not game.gameOver and game.isPlaying then
            game.isPaused = true
        else
            game.isPaused = false
        end

    end

    if player.isDead and key == "r" then
        game.restoreStage()

    elseif player.isDead and key == "escape" then
        game.restoreStage()
        
        -- aqui va la logica para guardar datos (seguir este orden de lineas de codigo)
        saveCurrentGame()

        game.restartStage()
        Change_state(require("src.scripts.states.menu"))
    end

    if game.gameOver and key == "r" then
        game.restartStage()

    elseif game.gameOver and key == "escape" then

        -- aqui va la logica para guardar datos (seguir este orden de lineas de codigo)
        saveCurrentGame()

        game.restartStage()
        Change_state(require("src.scripts.states.menu"))
    end

    if not game.isPaused and not game.gameOver and currentStage and currentStage.keypressed then
        currentStage.keypressed(key)
    end
    
end

function game.mousereleased(x, y)
    if game.isPaused then
        if (x > exitGame.x + (exitGame.w - 250)/2 and x < exitGame.x + (exitGame.w - 250)/2 + 250) and
            (y > exitGame.y + 15 + (exitGame.h - 50)/2 and y < exitGame.y + 65 + (exitGame.h - 50)/2) then
            
            -- aqui va la logica para guardar datos (seguir este orden de lineas de codigo)
            saveCurrentGame()
            game.restartStage()
            Change_state(require("src.scripts.states.menu"))
        end
    end

end

return game