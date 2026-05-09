local sounds = require("src.scripts.sounds.sounds")
local inputs = require("src.scripts.utils.inputs")
local playerCollisionBox = require("src.scripts.systems.collision_box")
local mathUtils = require("src.scripts.utils.mathUtils")

local animation = require("src.scripts.systems.animation")

local animations = {
    walk = animation.new("assets/sprites/player/player_walking.png", 19, 28, 0.25, false),
    run = animation.new("assets/sprites/player/player_running.png", 21, 28, 0.15, false),
    --[[bottleAttack = animation.new(),
    knifeAttack = animation.new(),
    batAttack = animation.new(),
    wrenchAttack = animation.new(), ]]
}

local currentAnimation = animations.walk

local isWalking = false
local isRunning = false

local player = {
    x = 0,
    y = 0,
    speed = 150,
    scale = 1,
    width = 19,
    height = 28,

    --sprideSheet base (de pie)
    frameWidth = 19,
    frameheight = 28,
    facingLeft = false,
    isMoving = false,

    isCrouching = false,
    armament = {isArmed = true, weaponSelect = "bottle"},
    HP = 1000,
    maxHP = 1000,
    isHurt = false,
    hurtTimer = 0,
    attacking = false,
    entityStatus = {
        statusType = "none",
        statusTimer = 0,
        lastAttacker = nil
    },

}

--#region Load, update y draw

function player.load()

    player.scale = (love.graphics.getWidth() / 256)
    player.y = love.graphics.getHeight() - player.frameheight * player.scale - 100
    player.x = 100

    playerCollisionBox.create(player, "bottom")

end

function player.update(dt)

    if player.isHurt then
        player.hurtTimer = player.hurtTimer - dt
        
        if player.hurtTimer <= 0 then
            player.isHurt = false
            player.hurtTimer = 0
        end
    end

    animation.update(currentAnimation, player.isMoving, dt)

    --logica de sonidos
    if player.isMoving then
        -- if isWalking then
        --     sounds.sound_effects.walk:play()
        -- else
        --     sounds.sound_effects.walk:pause()
        -- end
   
        -- if isRunning then
        --     sounds.sound_effects.run:play()
        -- else
        --     sounds.sound_effects.run:pause()
        -- end

    end

    player.checkDeath(dt)

end

function player.draw()

    love.graphics.setColor(0,1,0)
    love.graphics.rectangle("fill", player.x, player.y - 50, mathUtils.calculateHealthBarWidth(player.HP, player.maxHP), 15)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", player.x, player.y - 50, 100, 15)
    love.graphics.print(player.HP, player.x, player.y - 73, 0, 0.7)

    if player.isHurt then
        love.graphics.setColor(1,0,0)
    end

    local quad = animation.getQuad(currentAnimation)

    if not quad then
        return
    end
    
    local sheet = animation.getSheet(currentAnimation)

    if player.facingLeft then
        love.graphics.draw(sheet, quad, player.x + player.scale * player.frameWidth,
        player.y, 0, -player.scale, player.scale)
    else
        love.graphics.draw(sheet, quad, player.x, player.y, 0,
        player.scale, player.scale)
    end

end

--#endregion

local function setAnimation(animation)
    local newAnimation = animations[animation]
    if newAnimation and currentAnimation ~= newAnimation then
        currentAnimation = newAnimation
    end
end

--cambiar logica
function player.updateAnimationState()
    local isShift = love.keyboard.isDown(inputs.game.sprint) 
    
    local status = player.entityStatus and player.entityStatus.statusType
    local isNormal = status ~= "slow" and status ~= "stun"

    if player.isMoving then
        if isNormal then
            player.speed = isShift and 300 or 150
        end
        
        local anim = isShift and "run" or "walk"
        setAnimation(anim)
    else
        if isNormal then
            player.speed = 150
        end
        
        setAnimation("walk")
    end
end

--movimiento del player
function player.move(dt, XorY)

    if XorY == "x" then

        if love.keyboard.isDown(inputs.game.left) then
            player.isMoving = true
            player.facingLeft = true
            player.x = math.max(player.x - dt * player.speed, 0)
        elseif love.keyboard.isDown(inputs.game.right) then
            player.isMoving = true
            player.facingLeft = false
            player.x = player.x + dt * player.speed
        end

    elseif XorY == "y" then

        if love.keyboard.isDown(inputs.game.up) then
            player.isMoving = true
            player.y = math.max(player.y - dt * player.speed, 0)
        elseif love.keyboard.isDown(inputs.game.down) then
            player.isMoving = true
            player.y = math.min(player.y + dt * player.speed, love.graphics.getHeight() - player.scale * player.height)
        end

    end

end

function player.involuntaryMovement(dt, XorY, direction, factorSpeed, setback, obstacles)

    local cb = require("src.scripts.systems.collision_box")

    if XorY == "x" then

        if direction == "left" then
            player.x = math.max(player.x - dt * player.speed * factorSpeed * setback, 0)
        elseif direction == "right" then
            player.x = player.x + dt * player.speed * factorSpeed * setback
        end

    player.updateCollisionBox()

    --Resolver x
    for _, obs in ipairs(obstacles) do
        if cb.check(player, obs) then
            cb.resolveX(player, obs)
        end
    end
    
    elseif XorY == "y" then

        if direction == "up" then
            player.y = math.min(math.max(player.y - dt * player.speed * factorSpeed * setback, 0), love.graphics.getHeight() - player.scale * player.height)
        elseif direction == "down" then
            player.y = math.min(player.y + dt * player.speed * factorSpeed * setback, love.graphics.getHeight() - player.scale * player.height)
        end

    end

    player.updateCollisionBox()

    --Resolver y
    for _, obs in ipairs(obstacles) do
        if cb.check(player, obs) then
            cb.resolveY(player, obs)
        end
    end

end

local function takeHP(e, amountOfHP)
    e.HP = e.HP - amountOfHP

    if e.HP <= 0 then
        e.isDead = true
    end
end

function player.attack(enemies)

    for i, e in ipairs(enemies) do
        if mathUtils.getDistanceToPlayer(player, e) <= 75 and e.entityStatus.statusType ~= "stun" then
            player.attacking = true

            if player.armament.isArmed then
                    
                if player.armament.weaponSelect == "bottle" then
                    takeHP(e, 40)
                    --setAnimation("bottleAttack")
                    break

                elseif player.armament.weaponSelect == "knife" then
                    takeHP(e, 60)
                    --setAnimation("knifeAttack")
                    break

                elseif player.armament.weaponSelect == "bat" then
                    takeHP(e, 80)
                    --setAnimation("batAttack")
                    break

                elseif player.armament.weaponSelect == "wrench" then
                    takeHP(e, 100)
                    --setAnimation("wrenchAttack")
                    break
                end
            else
                takeHP(e, 20)
                --player.updateAnimationState()
                break
            end

        else
            player.attacking = false
        end
    end
end

function player.checkDeath(dt)
    if player.HP <= 0 then
        player.HP = 0
        player.die(dt)
    end
end

--testing
function player.die(dt)
    --logica al morir el player
end

return player