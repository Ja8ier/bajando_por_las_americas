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
    
    --ccarga el primer stage
    currentStage = stages[currentStageIndex]
    Change_state(stages[1])
    
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
            Change_state(currentStage)
        end
    else
        --final del juego
        gameOver = true
        isPlaying = false
    end

end

function game.restartStage()

    Change_state(currentStage)

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
end

return game