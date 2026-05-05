local game = {
    isPlaying = false,
    isPaused = false,
    gameOver = false
}
local stages = {}

local inputs = require("src.scripts.utils.inputs")
--local gui = require("src.scripts.gui.gui")

local currentStageIndex = 1
local currentStage = nil

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

function game.restartStage()

    if currentStage and currentStage.load then
        currentStage.load()
    end

    game.isPlaying = true
    game.gameOver = false
    game.isPaused = false

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

end

function game.draw()

    if currentStage and currentStage.draw then
        currentStage.draw()
    end

    if game.isPaused then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("PAUSA", love.graphics.getWidth()/2 - 120, love.graphics.getHeight()/2, 0, 2, 2)
        love.graphics.print("Presiona " .. inputs.game.pause[1] .. " o " .. string.upper(inputs.game.pause[2]) .. " para reanudar", 10, 10)
    end

    if game.gameOver then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("GAME OVER", love.graphics.getWidth()/2 - 190, love.graphics.getHeight()/2, 0, 2, 2)
        love.graphics.print("Presiona R para reiniciar, ESC para salir", 10, 10)
    end
end

function game.keypressed(key)

    if (type(inputs.game.pause) == "table" and (key == inputs.game.pause[1] or key == inputs.game.pause[2])) then

        if not game.isPaused and not game.gameOver then
            game.isPaused = true
        else
            game.isPaused = false
        end

    end

    if game.gameOver or key == "r" then
        --game.restartStage()
    end

    if not game.isPaused and not game.gameOver and currentStage and currentStage.keypressed then
        currentStage.keypressed(key)
    end

end

return game