local sounds = require("src.scripts.sounds.sounds")
local inputs = require("src.scripts.utils.inputs")
local playerCollisionBox = require("src.scripts.systems.collision_box")
local mathUtils = require("src.scripts.utils.mathUtils")
local animation = require("src.scripts.systems.animation")
local inventory = require("src.scripts.systems.inventory")
local tableUtils = require("src.scripts.utils.tableUtils")
local obstacle = require("src.scripts.entities.obstacle")
local projectile = require("src.scripts.systems.projectile")
local trigger = require("src.scripts.systems.trigger")
local cb = require("src.scripts.systems.collision_box")
local itemsDefinition = require("src.scripts.systems.itemsDefinition")

local scale = love.graphics.getWidth() / 256

local animations = {
    walk = animation.new("assets/sprites/player/player_walking.png", 19, 28, 0.25, false),
    run = animation.new("assets/sprites/player/player_running.png", 21, 28, 0.15, false),
    crouch = animation.new("assets/sprites/player/player_crouch.png", 22, 28, 0.1, true),
    attack = animation.new("assets/sprites/player/player_attack.png", 31, 31, 0.080, false),
    punch = animation.new("assets/sprites/player/player_punch.png", 24, 28, 0.1, false),
    walkWileCarry = animation.new("assets/sprites/player/player_walking_while_carring.png", 20, 29, 0.25, false),
    carry = animation.new("assets/sprites/player/player_carry.png", 17, 28, 0.1, true)
}

local currentAnimation = animations.walk

local wasAttackPressed = false
local attackTimer = 0
local attackDuration = 0.4

local wearLosen = 0

local objectCarried = {image = nil, scale = 1, width = 0, height = 0, x = 0, y = 0, collisionType = ""}
local objectToSave

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
    armament = {isArmed = false, weaponSelect = "bottle"},
    HP = 1000,
    maxHP = 1000,
    numberAttempts = 3,
    isHurt = false,
    hurtTimer = 0,
    attacking = false,
    entityStatus = {statusType = "none", statusTimer = 0},
    isCarringObject = false
}

--#region Load, update y draw

function player.load(spawnPoint)

    player.scale = scale
    player.x = spawnPoint.x
    player.y = spawnPoint.y

    playerCollisionBox.create(player, "bottom")

end

local hasImpacted = false
function player.update(dt, enemies)

    --recorre el inventario y evalua si en la casilla selected hay un arma y la coloca al player
    for i = 1, 9 do
        if player.inventory[i].item ~= nil and player.inventory[i].isSelected then
            if player.inventory[i].item.itemType == ITEM_TYPES.WEAPON and player.inventory[i].item.hasWear then
                player.armament.isArmed = true
                player.armament.weaponSelect = player.inventory[i].item.id
            end
            break
        else
            player.armament.isArmed = false
        end
    end

    player.inventory.update(dt)

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

    if projectile.isActive then
        projectile.update(dt, player.facingLeft)

        if not projectile.isActive and not hasImpacted then

            local impactTrigger = trigger.new(projectile.getGroundX() / scale, projectile.getGroundY() / scale,
                objectToSave.collisionBox.width / scale, objectToSave.collisionBox.height * 2 / scale, true, nil, true, nil)

            player.hurtEnemiesByDistance(enemies, impactTrigger)

            hasImpacted = true
            objectToSave = nil
        end
    end

    player.checkDeath(dt)

end

local function drawCarryableObject()
    if objectCarried.width > player.collisionBox.width then
        objectCarried.x = player.x - ((objectCarried.width  - player.collisionBox.width))
    elseif objectCarried.width < player.collisionBox.width then
        objectCarried.x = player.x + (player.collisionBox.width) - objectCarried.width * objectCarried.scale
    end

    objectCarried.y = player.y - objectCarried.height * objectCarried.scale

    love.graphics.draw(objectCarried.image, objectCarried.x, objectCarried.y + 20, 0, objectCarried.scale, objectCarried.scale)
end

function player.draw()

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

    love.graphics.setColor(1,1,1)

    --Player levantando un objeto
    if player.isCarringObject then
        drawCarryableObject()
    end

    if projectile.isActive then
        projectile.draw()
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

function player.updateAnimationState(dt)

    if love.keyboard.isDown(inputs.game.crouch) then
        setAnimation("crouch")
        player.speed = 0
        player.isCrouching = true
        return
    end

    if player.isCarringObject then
        setAnimation("walkWileCarry")
        player.speed = 150
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
        player.speed = 0
    end

    wasAttackPressed = isAttackPressed

    if attackTimer > 0 then
        attackTimer = attackTimer - dt
        return
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

function player.getWearLosen()
    local aux = wearLosen
    wearLosen = 0
    return aux
end

local function takeHP(e, amountOfHP)

    if amountOfHP > 20 and amountOfHP < 150 then
        wearLosen = amountOfHP / 2
    end

    e.HP = e.HP - amountOfHP

    if e.HP <= 0 then
        e.isDead = true
        e.HP = 0
    end
end

function player.attack(enemies)

    if player.isCarringObject and objectCarried ~= nil then
        player.throw(objectCarried)
        return
    end

    if player.inventory.getItemSelectSlot() ~= nil then
        if player.inventory.getItemSelectSlot().itemType == ITEM_TYPES.PROJECTILE then
            player.throw(player.inventory.getItemSelectSlot())
            return
        end
    end

    for i, e in ipairs(enemies) do
        if mathUtils.getDistanceToPlayer(player, e) <= 75 and e.entityStatus.statusType ~= "stun" then
            if not player.isCarringObject then
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

function player.pickItem(_items, _pickableItem, _inventory)
    if player.inventory.hasSpace(_inventory) then
        tableUtils.removeByValue(_items, _pickableItem)
        _inventory.insert(_pickableItem, 1)
    end
end

function player.dropItem(_items, _inventory)

    for i = 1,9 do
        if _inventory[i].isSelected and _inventory[i].item ~= nil then

            --Mejorar las restricciones de los bordes del mundo

            local item = inventory[i].item
            local itemX = player.x + player.collisionBox.width
            local itemY = player.collisionBox.y + player.collisionBox.height - _inventory[i].item.sprite:getHeight()

            if player.facingLeft then
                itemX = player.x - player.collisionBox.width
            end

            if (not player.facingLeft and itemX >= love.graphics.getWidth()) or (player.facingLeft and itemX <= 0) then
                itemX = player.x
            end

            item.x = itemX
            item.y = itemY

            table.insert(_items, item)
            player.inventory.remove(item)
            return
        end
    end

end

function player.carryObject(objects, object)
    if object ~= nil then
        tableUtils.removeByValue(objects, object)
        player.isCarringObject = true
        objectCarried.image = object.texture
        objectCarried.scale = object.scale
        objectCarried.width = object.width
        objectCarried.height = object.height
        objectCarried.collisionType = object.collisionBox.type
        objectToSave = obstacle.new(true, object.x / scale, object.y / scale,
        object.width, object.height, object.collisionBox.type, object.texture, true, object.scale / scale)
    else
        return
    end
end

function player.leaveObject()
    player.isCarringObject = false

    if player.facingLeft then
        objectToSave.x = player.x - player.collisionBox.width
    else
        objectToSave.x = player.x + player.collisionBox.width
    end

    --agregar las restricciones de los bordes del mundo
    objectToSave.y = player.y + player.height - objectToSave.collisionBox.height

    require("src.scripts.systems.collision_box").updatePosition(objectToSave)
    return objectToSave

end

function player.hurtEnemiesByDistance(enemies, tr)
    if tr == nil then
        return
    end
    for _, e in ipairs(enemies) do
        if cb.checkInteractionCollision(e, tr) then
            takeHP(e, 150)
        end
    end
end

function player.throw(item)
    if item.itemType == ITEM_TYPES.PROJECTILE then
    else
        player.isCarringObject = false
        projectile.new(350, 45, objectCarried.x, objectCarried.y, player.y + player.height, true, objectToSave.texture, objectToSave.scale, 2560 * scale)
        projectile.isActive = true
        projectile.throw()
        hasImpacted = false
        objectCarried = nil
    end
end

return player