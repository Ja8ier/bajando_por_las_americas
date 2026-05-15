local inputs = require("src.scripts.utils.inputs")

local qte = {}

local exit

--configuraciones
local config = {
    baseLength = 3,
    maxLength = 6,
    maxLevel = 3,
    showDelay = 0.8,
    inputTimeLimit = 1.5,
    transitionDelay = 0.6
}

-- estado
local sequence = {}
local currentIndex = 1
local state = "start"

local timer = 0
local showIndex = 1
local inputTimer = 0
local flashTimer = 0
local transitionTimer = 0

local level = 1
local sequenceLength = config.baseLength

local possibleInputs = {
    inputs.minigames["1"].up,
    inputs.minigames["1"].down,
    inputs.minigames["1"].left,
    inputs.minigames["1"].right
}

local lastFeedback = ""

--assets
local images = {}
local sounds = {}
local bg = nil
local font = nil
local titleFont = nil

--ui
local blinkTimer = 0
local showPress = true

--is Win
local gameCompleted = false

--carga de assets
local function loadAssets()
    if images.up then return end

    -- Flechas
    images.up = love.graphics.newImage("assets/sprites/minigames/qte/up_arrow.png")
    images.down = love.graphics.newImage("assets/sprites/minigames/qte/down_arrow.png")
    images.left = love.graphics.newImage("assets/sprites/minigames/qte/left_arrow.png")
    images.right = love.graphics.newImage("assets/sprites/minigames/qte/right_arrow.png")

    -- Fondo
    bg = love.graphics.newImage("assets/sprites/minigames/qte/bg.jpg")

    -- Fuentes
    font = love.graphics.newFont("assets/fonts/VT323-Regular.ttf", 28)
    titleFont = love.graphics.newFont("assets/fonts/VT323-Regular.ttf", 48)

    love.graphics.setFont(font)

    -- Sonidos
    sounds.correct = love.audio.newSource("assets/sounds/minigames/qte/correct.wav", "static")
    sounds.wrong = love.audio.newSource("assets/sounds/minigames/qte/wrong.wav", "static")
    sounds.show = love.audio.newSource("assets/sounds/minigames/qte/show.wav", "static")
    sounds.start = love.audio.newSource("assets/sounds/minigames/qte/start.wav", "static")

    love.audio.setVolume(0.8)
end

--generar secuencia
local function generateSequence()
    sequence = {}
    for i = 1, sequenceLength do
        table.insert(sequence, possibleInputs[math.random(#possibleInputs)])
    end
end

--inicio de ronda
local function beginRound()
    currentIndex = 1
    state = "showing"

    timer = 0
    flashTimer = 0
    showIndex = 1
    inputTimer = config.inputTimeLimit

    sequenceLength = math.min(config.baseLength + (level - 1), config.maxLength)

    generateSequence()
end

function qte.load()
    exit = false
    loadAssets()
    state = "start"
    level = 1
end

function qte.update(dt)

    if exit == true then
        return
    end

    blinkTimer = blinkTimer + dt
    if blinkTimer >= 0.5 then
        blinkTimer = 0
        showPress = not showPress
    end

    if state == "showing" then
        timer = timer + dt
        flashTimer = flashTimer + dt

        if timer >= config.showDelay then
            timer = 0
            flashTimer = 0

            showIndex = showIndex + 1

            if showIndex <= #sequence then
                sounds.show:clone():play()
            end

            if showIndex > #sequence then
                state = "transition"
                transitionTimer = config.transitionDelay
            end
        end

    elseif state == "transition" then
        transitionTimer = transitionTimer - dt

        if transitionTimer <= 0 then
            state = "input"
        end

    elseif state == "input" then
        inputTimer = inputTimer - dt

        if inputTimer <= 0 then
            state = "fail"
        end
    end
end

function qte.keypressed(key)

    if key == inputs.minigames["1"].quit then
        if state == "success" then
            if level < config.maxLevel then gameCompleted = false else gameCompleted = true end
        end
        exit = true
    end

    if state == "start" then
        if key == inputs.minigames["1"].continue then
            sounds.start:clone():play()
            beginRound()
        end
        return
    end

    if state == "success" then
        if key == inputs.minigames["1"].continue then
            if level < config.maxLevel then
                level = level + 1
                beginRound()
            end
        end
        return
    end

    if state == "fail" then
        if key == inputs.minigames["1"].restart then
            level = 1
            beginRound()
        end
        return
    end

    if state ~= "input" then return end

    if key == sequence[currentIndex] then
        sounds.correct:clone():play()

        currentIndex = currentIndex + 1
        lastFeedback = "Correcto!"

        if currentIndex > #sequence then
            state = "success"
        end
    else
        sounds.wrong:clone():play()

        lastFeedback = "Incorrecto!"
        state = "fail"
    end
end

function qte.isExited()

    if exit then
        exit = false

        if gameCompleted then
            return true, gameCompleted
        end

        return true, gameCompleted
    end

end

function qte.draw()

    if exit then
        return
    end

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1)
    
    -- Fondo
    if bg then
        love.graphics.setColor(1,1,1)
        love.graphics.draw(bg, 0, 0, 0,
            w / bg:getWidth(),
            h / bg:getHeight())
    end

    local cx = w/2
    local cy = h/2

    --pantalla inicio
    if state == "start" then
        love.graphics.setFont(titleFont)
        love.graphics.setColor(0,1,1)
        love.graphics.printf("QTE SYSTEM", 0, 40, w, "center")

        love.graphics.setFont(font)
        love.graphics.setColor(1,1,1)
        love.graphics.printf("Memoriza la secuencia de flechas", 0, 200, w, "center")
        love.graphics.printf("y repítela correctamente", 0, 240, w, "center")

        love.graphics.printf("↑   ↓   ←   →", 0, 320, w, "center")

        if showPress then
            love.graphics.setColor(0,1,0)
            love.graphics.printf("Presiona ENTER para comenzar", 0, 420, w, "center")
        end

        love.graphics.setColor(1,1,1)
        return
    end

    love.graphics.setFont(titleFont)
    love.graphics.setColor(0,1,1)
    love.graphics.printf("QTE SYSTEM", 0, 20, w, "center")

    --UI normal
    love.graphics.setFont(font)
    love.graphics.setColor(1,1,1)
    love.graphics.printf("Nivel: "..level, 0, 80, w, "center")

    local arrowPositions = {
        up =    {x = cx, y = cy - 120},
        down =  {x = cx, y = cy + 120},
        left =  {x = cx - 140, y = cy},
        right = {x = cx + 140, y = cy}
    }

    if state == "showing" then
        love.graphics.printf("Memoriza", 0, cy - 180, w, "center")

        if showIndex <= #sequence then
            local dir = sequence[showIndex]
            local arrow = images[dir]
            local pos = arrowPositions[dir]

            if arrow and pos then
                local alpha = 1 - (flashTimer / config.showDelay)
                if alpha < 0 then alpha = 0 end

                love.graphics.setColor(1,1,1, alpha)

                local scale = 2.5
                local ax = pos.x - (arrow:getWidth()*scale)/2
                local ay = pos.y - (arrow:getHeight()*scale)/2

                love.graphics.draw(arrow, ax, ay, 0, scale, scale)
                love.graphics.setColor(1,1,1,1)
            end
        end

    elseif state == "transition" then
        love.graphics.setColor(1,1,1,0.5)
        love.graphics.printf("...", 0, cy, w, "center")

    elseif state == "input" then
        love.graphics.printf("Repite!", 0, cy - 180, w, "center")

        love.graphics.printf("Tiempo: "..math.ceil(inputTimer), 0, cy + 120, w, "center")
        love.graphics.printf("Progreso: "..(currentIndex-1).."/"..#sequence, 0, cy + 150, w, "center")

        if lastFeedback == "Correcto!" then
            love.graphics.setColor(0,1,0)
        elseif lastFeedback == "Incorrecto!" then
            love.graphics.setColor(1,0,0)
        end

        love.graphics.printf(lastFeedback, 0, cy + 180, w, "center")
        love.graphics.setColor(1,1,1)

    elseif state == "success" then
        love.graphics.setColor(0,1,0)
        love.graphics.printf("SUCCESS", 0, cy, w, "center")

        if level < config.maxLevel then
            love.graphics.printf("ENTER", 0, cy + 50, w, "center")
        else
            love.graphics.printf("PRESIONA CTRL PARA SALIR", 0, cy + 65, w, "center")
        end

    elseif state == "fail" then
        love.graphics.setColor(1,0,0)
        love.graphics.printf("FAIL", 0, cy, w, "center")
        love.graphics.printf("R PARA REINTENTAR", 0, cy + 50, w, "center")
    end

    love.graphics.setColor(1,1,1)
end

function qte.isFinished()
    return state == "success" or state == "fail"
end

function qte.getReward()
    if state == "success" then
        return 20 + (level * 2)
    else
        return 5
    end
end

return qte