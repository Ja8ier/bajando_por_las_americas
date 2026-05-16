local bomb = {}

local Wires = require("src.scripts.states.minigames.bomb defusal.modules.wires")
local Buttons = require("src.scripts.states.minigames.bomb defusal.modules.buttons")
local Energy = require("src.scripts.states.minigames.bomb defusal.modules.energy")
local Keypad = require("src.scripts.states.minigames.bomb defusal.modules.keypad")
local HUD = require("src.scripts.states.minigames.bomb defusal.ui.hud")
local Briefing = require("src.scripts.states.minigames.bomb defusal.ui.briefing")
local Effects = require("src.scripts.states.minigames.bomb defusal.effects.effects")
local inputs = require("src.scripts.utils.inputs")

-- VARIABLES
local state = "briefing"
local font, titleFont, timerFont, buttonFont
local blinkTimer = 0
local showPress = true
local bombTimer = 30
local exit
local gameCompleted = false

-- GAMEPLAY
local currentStep = 1
local maxSteps = 8
local currentInstruction = nil
local currentMode = "wire"
local gameplayPhase = "main"

-- BACKGROUND & AUDIO
local background
local dangerSound
local dangerPlaying = false
local interactSound
local explosionSound
local ambientMusic

-- FINAL BUTTON
local finalButtonSprite
local finalButton = { x = 425, y = 120, scale = 0.42, hover = false }
local targetButton = 1
local wireSprites = {}

-- RANDOM GAMEPLAY & STEPS
local function generateChallenge()
    local randomType = math.random(1, 2)
    if randomType == 1 then
        currentMode = "wire"
        local colors = { "red", "blue", "green", "yellow" }
        currentInstruction = colors[math.random(#colors)]
    else
        currentMode = "button"
        targetButton = math.random(1, 4)
    end
end

local function nextStep()
    Effects.triggerShake(3)
    currentStep = currentStep + 1
    if currentStep > maxSteps then
        gameplayPhase = "energy"
        return
    end
    generateChallenge()
end

local function resetGameState()
    state = "briefing"
    bombTimer = 30
    currentStep = 1
    currentInstruction = nil
    currentMode = "wire"
    gameplayPhase = "main"
    blinkTimer = 0
    showPress = true
    dangerPlaying = false

    Energy.reset()
    Keypad.reset()
    Briefing.reset()
end

local function playInteract()
    interactSound:stop()
    interactSound:play()
end

local function playExplosion()
    explosionSound:stop()
    explosionSound:play()
end

function bomb.load()
    exit = false
    gameCompleted = false

    math.randomseed(os.time())
    background = love.graphics.newImage("assets/sprites/miniGames/bomb defusal/bg.png")

    -- FONTS
    font = love.graphics.newFont("assets/fonts/PressStart2P-Regular.ttf", 16)
    titleFont = love.graphics.newFont("assets/fonts/PressStart2P-Regular.ttf", 32)
    timerFont = love.graphics.newFont("assets/fonts/PressStart2P-Regular.ttf", 54)
    buttonFont = love.graphics.newFont("assets/fonts/PressStart2P-Regular.ttf", 18)

    -- WIRES
    wireSprites.red = love.graphics.newImage("assets/sprites/miniGames/bomb defusal/red_wire.png")
    wireSprites.blue = love.graphics.newImage("assets/sprites/miniGames/bomb defusal/blue_wire.png")
    wireSprites.green = love.graphics.newImage("assets/sprites/miniGames/bomb defusal/green_wire.png")
    wireSprites.yellow = love.graphics.newImage("assets/sprites/miniGames/bomb defusal/yellow_wire.png")

    -- MODULE LOADS
    Wires.load(wireSprites)
    Buttons.load()
    Energy.load()
    Keypad.load()
    generateChallenge()

    -- SPRITES & AUDIO
    finalButtonSprite = love.graphics.newImage("assets/sprites/miniGames/bomb defusal/final_button.png")
    dangerSound = love.audio.newSource("assets/sounds/minigames/bomb defusal/danger.wav", "stream")
    dangerSound:setLooping(true)    
    interactSound = love.audio.newSource("assets/sounds/minigames/bomb defusal/show.wav", "static")
    interactSound:setVolume(0.5)
    explosionSound = love.audio.newSource("assets/sounds/minigames/bomb defusal/explotion.flac", "static")
    explosionSound:setVolume(0.8)
    ambientMusic = love.audio.newSource("assets/sounds/minigames/bomb defusal/ambient.wav", "stream")
    ambientMusic:setLooping(true)
    ambientMusic:setVolume(1)
end

function bomb.update(dt)

    if exit == true then
        return
    end

    blinkTimer = blinkTimer + dt
    if blinkTimer >= 0.5 then
        blinkTimer = 0
        showPress = not showPress
    end

    if state == "playing" then
        bombTimer = bombTimer - dt
        if bombTimer <= 0 then
            bombTimer = 0
            state = "fail"
            ambientMusic:stop()            
            playExplosion()
            Effects.triggerShake(12)
            Effects.triggerFlash(0.7, 2)
        end

        -- DANGER SOUND
        if bombTimer <= 10 and not dangerPlaying then
            dangerSound:play()
            dangerPlaying = true
        end
    end

    Effects.update(dt)

    if state == "briefing" then Briefing.update(dt) end

    -- MODULE UPDATES
    Wires.update()
    Buttons.update()

    if gameplayPhase == "energy" and state == "playing" then Energy.update(dt) end
    if gameplayPhase == "keypad" and state == "playing" then Keypad.update() end

    -- FINAL BUTTON HOVER
    if gameplayPhase == "finalButton" then
        local mx, my = love.mouse.getPosition()
        local w = finalButtonSprite:getWidth() * finalButton.scale
        local h = finalButtonSprite:getHeight() * finalButton.scale
        finalButton.hover = (mx >= finalButton.x and mx <= finalButton.x + w and my >= finalButton.y and my <= finalButton.y + h)
    end
end

function bomb.draw()

    if exit then return end

    local bgScaleX = love.graphics.getWidth() / background:getWidth()
    local bgScaleY = love.graphics.getHeight() / background:getHeight()

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(background, 0, 0, 0, bgScaleX, bgScaleY)

    -- EFFECTS
    Effects.drawLowTimeWarning(bombTimer)
    local offsetX, offsetY = Effects.getShakeOffset()

    love.graphics.push()
    love.graphics.translate(offsetX, offsetY)

    -- BRIEFING / START SCREEN
    if state == "briefing" then
        Briefing.draw(font)
    elseif state == "start" then
        HUD.drawStartScreen(titleFont, font, showPress)

    -- PLAYING MODES
    elseif state == "playing" then
        HUD.drawTimer(bombTimer, timerFont)
        HUD.drawInstruction(gameplayPhase, currentMode, currentInstruction, targetButton, font)

        if gameplayPhase == "main" then
            Wires.draw()
            Buttons.draw(buttonFont)
        elseif gameplayPhase == "energy" then
            Energy.draw(font)
        elseif gameplayPhase == "keypad" then
            Keypad.draw(font)
        elseif gameplayPhase == "finalButton" then
            love.graphics.setFont(font)
            love.graphics.setColor(1, 0, 0)
            love.graphics.printf("PRESIONA EN EL ULTIMO SEGUNDO", 0, 120, love.graphics.getWidth(), "center")
            love.graphics.setColor(1, 1, 1)

            -- GLOW
            if finalButton.hover then
                love.graphics.setColor(1, 0.2, 0.2, 0.35)
                love.graphics.draw(finalButtonSprite, finalButton.x - 6, finalButton.y - 6, 0, finalButton.scale + 0.015, finalButton.scale + 0.015)
            end

            -- MAIN BUTTON
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(finalButtonSprite, finalButton.x, finalButton.y, 0, finalButton.scale, finalButton.scale) 
        end

    -- END STATES
    elseif state == "win" then
        HUD.drawWinScreen(titleFont)
    elseif state == "fail" then
        HUD.drawFailScreen(titleFont, font)
    end

    love.graphics.pop()

    -- OVERLAY EFFECTS
    Effects.drawScanlines()
    Effects.drawFlash()

    -- EXIT TEXT
    love.graphics.setColor(1, 1, 1, 0.6)
    love.graphics.setFont(font)
    love.graphics.print("Presiona CTRL para salir", love.graphics.getWidth() - 420, love.graphics.getHeight() - 30)
end

function bomb.keypressed(key)

    if key == inputs.minigames["1"].quit then
        if state == "win" then gameCompleted = true else gameCompleted = false end
        ambientMusic:stop()
        dangerSound:stop()
        interactSound:stop()
        explosionSound:stop()
        resetGameState()
        exit = true
    end

    if state == "briefing" and Briefing.isFinished() and key == inputs.minigames["1"].continue then
        playInteract()
        state = "start"
        return
    end

    if state == "start" and key == inputs.minigames["1"].continue then
        playInteract()
        ambientMusic:play()
        state = "playing"
        generateChallenge()
    end

    -- ENERGY PANEL
    if gameplayPhase == "energy" and key == inputs.minigames["1"].space and state == "playing" then
        playInteract()
        if Energy.checkSuccess() then
            gameplayPhase = "keypad"
            Keypad.generate()
        else
            state = "fail"
            playExplosion()
            ambientMusic:stop()
            Effects.triggerShake(12)
            Effects.triggerFlash(0.8, 2)
        end
    end

    -- RESTART
    if state == "fail" and key == inputs.minigames["1"].restart then
        ambientMusic:stop()
        dangerSound:stop()
        dangerPlaying = false
        state = "start"
        bombTimer = 30
        currentStep = 1
        gameplayPhase = "main"
        Energy.reset()
        Keypad.reset()
        generateChallenge()
        return
    end
end

function bomb.isExited()
    if exit then
        exit = false

        if gameCompleted then
            return true, gameCompleted
        end
        return true, gameCompleted
    end
end

function bomb.mousepressed(x, y, button)
    if state ~= "playing" then return end

    -- MAIN GAMEPLAY
    if gameplayPhase == "main" then
        -- WIRES
        local clickedWire = Wires.checkClick(x, y)
        if clickedWire then
            playInteract()
            if clickedWire == currentInstruction then nextStep()
            else
                state = "fail"
                playExplosion()
                ambientMusic:stop()
                dangerSound:stop()
                dangerPlaying = false
                Effects.triggerShake(12)
                Effects.triggerFlash(0.8, 2)
            end
        end

        -- BUTTONS
        local clickedButton = Buttons.checkClick(x, y)
        if clickedButton then
            playInteract()
            if clickedButton == targetButton then nextStep()
            else
                state = "fail"
                playExplosion()
                ambientMusic:stop()
                dangerSound:stop()
                dangerPlaying = false
                Effects.triggerShake(12)
                Effects.triggerFlash(0.8, 2)
            end
        end

    -- KEYPAD
    elseif gameplayPhase == "keypad" then
        local result = Keypad.checkClick(x, y)
        if result then playInteract() end    

        if result == "fail" then
            state = "fail"
            playExplosion()
            ambientMusic:stop()
            dangerSound:stop()
            dangerPlaying = false
            Effects.triggerShake(12)
            Effects.triggerFlash(0.8, 2)
        elseif result == "success" then
            gameplayPhase = "finalButton"
            Effects.triggerShake(5)
        end

    -- FINAL BUTTON
    elseif gameplayPhase == "finalButton" then
        if finalButton.hover then
            playInteract()    
            if bombTimer <= 1 and bombTimer > 0 then
                state = "win"
                gameCompleted = true
                ambientMusic:stop()
                dangerSound:stop()
                dangerPlaying = false
                Effects.triggerShake(8)
            else
                state = "fail"
                gameCompleted = false
                playExplosion()
                ambientMusic:stop()
                dangerSound:stop()
                dangerPlaying = false
                Effects.triggerShake(15)
                Effects.triggerFlash(1, 2)
            end
        end
    end
end

return bomb