local game = {}
local stages = {}

local inputs = require("src.scripts.utils.inputs")

local currentStageIndex = 1
local currentStage = nil
local isPlaying = true
local isPaused = false
local gameOver = false

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
    
    isPlaying = true
    isPaused = false
    gameOver = false
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
        gameOver = true
        isPlaying = false
    end

end

function game.restartStage()

    if currentStage and currentStage.load then
        currentStage.load()
    end

    isPlaying = true
    gameOver = false
    isPaused = false
end

function game.update(dt)

    if not isPlaying or gameOver then
        return
    end

    if isPaused then

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

    if isPaused then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("PAUSA", love.graphics.getWidth()/2, love.graphics.getHeight()/2, 0, 2, 2)
        love.graphics.print("Presiona " .. inputs.game.pause[1] .. " para reanudar", love.graphics.getWidth()/2, love.graphics.getHeight()/2 + 50)
    end

    if gameOver then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("GAME OVER", love.graphics.getWidth()/2, love.graphics.getHeight()/2, 0, 2, 2)
        love.graphics.print("Presiona R para reiniciar, ESC para salir", love.graphics.getWidth()/2, love.graphics.getHeight()/2 + 50)
    end
end

function game.keypressed(key)

     if (type(inputs.game.pause) == "table" and (key == inputs.game.pause[1] or key == inputs.game.pause[2])) then
        Change_state(require("src.scripts.states.menu"))
        -- if gameOver then
        -- else
        --     isPaused = not isPaused
        -- end
    end

    if key == "m" then
        gameOver =true
    end
    if key == "n" then
        isPaused =true
    end

    if gameOver or key == "r" then
       -- game.restartStage()
    end

    if not isPaused and not gameOver and currentStage and currentStage.keypressed then
        currentStage.keypressed(key)
    end
    
end

return game