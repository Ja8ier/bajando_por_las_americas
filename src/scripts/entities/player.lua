local sounds = require("src.scripts.sounds.sounds")
local inputs = require("src.scripts.utils.inputs")
local playerCollisionBox = require("src.scripts.systems.collision_box")
local mathUtils = require("src.scripts.utils.mathUtils")
local animation = require("src.scripts.systems.animation")
local inventory = require("src.scripts.systems.inventory")

local scale = love.graphics.getWidth() / 256

local animations = {
    walk = animation.new("assets/sprites/player/player_walking.png", 19, 28, 0.25, false),
    run = animation.new("assets/sprites/player/player_running.png", 21, 28, 0.15, false),
    crouch = animation.new("assets/sprites/player/player_crouch.png", 22, 28, 0.1, true),
    attack = animation.new("assets/sprites/player/player_attack.png", 31, 31, 0.080, false),
    punch = animation.new("assets/sprites/player/player_punch.png", 24, 28, 0.1, false),
    walkWileCarry = animation.new("assets/sprites/player/player_walking_while_carring.png", 20, 29, 0.25, false),
}

local currentAnimation = animations.walk

local wasAttackPressed = false
local attackTimer = 0
local attackDuration = 0.4

local player = {
    x = 0,
    y = 0,
    speed = 150,
    scale = 1,
    width = 19,
    height = 28,
    type = "player",

    inventory = inventory,

    --sprideSheet base (de pie)
    frameWidth = 19,
    frameheight = 28,
    facingLeft = false,
    isMoving = false,

    isDead = false,
    isCrouching = false,
    armament = {isArmed = true, weaponSelect = "bottle"},
    HP = 1000,
    maxHP = 1000,
    numberAttempts = 3,
    isHurt = false,
    hurtTimer = 0,
    attacking = false,
    entityStatus = {statusType = "none", statusTimer = 0}
}

--#region Load, update y draw

function player.load(spawnPoint)

    player.scale = scale
    player.x = spawnPoint.x
    player.y = spawnPoint.y

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

    local oldMoving = player.isMoving
    if currentAnimation == animations.punch or currentAnimation == animations.attack then
        player.isMoving = true
    end

    animation.update(currentAnimation, player.isMoving, dt)
    player.isMoving = oldMoving
    -- animation.update(currentAnimation, player.isMoving, dt)

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

    if player.isHurt then
        --cambiar por animacion de damage
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
    
    love.graphics.setColor(1,1,1)

end

--#endregion

local function setAnimation(animation)
    local newAnimation = animations[animation]
    if newAnimation and currentAnimation ~= newAnimation then
        currentAnimation = newAnimation
    end
end

--cambiar logica

function player.updateAnimationState(dt)

    if love.keyboard.isDown(inputs.game.crouch) then
        setAnimation("crouch")
        player.speed = 0
        player.isCrouching = true
        return
    end

    local isAttackPressed = love.keyboard.isDown(inputs.game.attack)

    if isAttackPressed and not wasAttackPressed then
        attackTimer = attackDuration
        if player.armament.isArmed then
            setAnimation("attack")
        else
            setAnimation("punch")
        end
        player.speed = 0 -- Te detienes al atacar
    end

    wasAttackPressed = isAttackPressed

    if attackTimer > 0 then
        attackTimer = attackTimer - dt
        return -- Salimos: el ataque bloquea el movimiento y el sprint
    end

    local status = player.entityStatus and player.entityStatus.statusType
    local isNormal = status ~= "slow" and status ~= "stun"
    local isShift = love.keyboard.isDown(inputs.game.sprint)

    if player.isMoving then
        player.isCrouching = false

        if isNormal then
            if isShift then
                player.speed = 300
                setAnimation("run")
            else
                player.speed = 150
                setAnimation("walk")
            end
        else
            setAnimation("walk")
        end
    else
        player.isCrouching = false
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

function player.dropItem(items, itemIndex)

    --table.insert(items, inventory[itemIndex])
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

        player.updateCollisionBox()

        --Resolver y
        for _, obs in ipairs(obstacles) do
            if cb.check(player, obs) then
                cb.resolveY(player, obs)
            end
        end
    end
end

local function takeHP(e, amountOfHP)
    e.HP = e.HP - amountOfHP

    if e.HP <= 0 then
        e.isDead = true
        e.HP = 0
    end
end

function player.attack(enemies)

    for i, e in ipairs(enemies) do
        if mathUtils.getDistanceToPlayer(player, e) <= 75 and e.entityStatus.statusType ~= "stun" then
            player.attacking = true
            player.isCrouching = false

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

function player.cleanStatus()
    player.speed = 150
    player.facingLeft = false
    player.isMoving = false
    player.isCrouching = false
    player.isDead = false
    player.armament = {isArmed = true, weaponSelect = "bottle"}
    player.HP = 1000
    player.numberAttempts = 3
    player.isHurt = false
    player.hurtTimer = 0
    player.attacking = false
    player.entityStatus = {statusType = "none", statusTimer = 0}
    currentAnimation = animations.walk
end

function player.checkDeath(dt)
    if player.HP <= 0 then
        player.HP = 0
    end
end


return player