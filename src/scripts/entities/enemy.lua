local Enemy = {}
Enemy.__index = Enemy
local EnemyCollisionBox = require("src.scripts.systems.collision_box")
local EnemyLogic = require("src.scripts.logic.enemy_logic")
local mathUtils = require("src.scripts.utils.mathUtils")
local entityStateSystem = require("src.scripts.systems.entity_state_system")
local animation = require("src.scripts.systems.animation")
local scale = love.graphics.getWidth() / 256

NextBossWeaponIndex = 1 -- guarda el indice del boss del nivel actual

local WeaponsByTier = {
    [1] = {"bottle"},
    [2] = {"bottle", "knife"},
    [3] = {"bottle", "knife", "bat"},
    [4] = {"bottle", "knife", "bat", "wrench"}
}

local entitiesStates = {
    {state = "knockback", duration = 0.5},
    {state = "stun", duration= 2},
    {state = "slow", duration = 4},
    {state = "bleed", duration = 3}
}

local baseDamage = {
    -- daño base de ataques sin armas
    jabAttack = 10,
    comboAttack = 30,
    sweepKick = 20,
    groundSlam = 40,
    heavySmash = 50,

    -- daño base de ataques con armas
    commonWeaponAttack = 30,
    specialBottleAttack = 40,
    specialKnifeAttack = 50,
    specialBatAttack = 60,
    specialWrenchAttack = 70
}

local multipliers = {
    [1] = 1,
    [2] = 1.3,
    [3] = 1.5,
    [4] = 1.8,
    [5] = {2, 2.1, 2.2, 2.3} or 1
}

local dimensions = {

    [1] = { walk={40, 60}, heal={57, 62}, die={62, 59}, attack={60, 59}, jabAttack={64, 59}, comboAttack={64, 58}, sweepKick={48, 59}, scale = 0.5 }, --tier1
    [2] = { walk={40, 60}, heal={57, 62}, die={62, 59}, attack={60, 59}, jabAttack={64, 59}, comboAttack={64, 58}, sweepKick={48, 59}, groundSlam={61, 63}, scale = 0.5 }, --tier2
    [3] = { walk={40, 60}, heal={57, 62}, die={62, 59}, attack={60, 59}, jabAttack={64, 59}, comboAttack={64, 58}, sweepKick={48, 59}, groundSlam={61, 63}, heavySmash={49, 64}, scale = 0.5 }, --tier3
    [4] = { walk={40, 60}, heal={57, 62}, die={62, 59}, attack={60, 59}, jabAttack={64, 59}, comboAttack={64, 58}, sweepKick={48, 59}, groundSlam={61, 63}, heavySmash={49, 64}, scale = 0.5 }, --tier4
    [5] = {{ walk={41, 61}, attack={63, 56}, heal={59, 64}, die={59, 62}, scale = 0.7 }, --boss1
            { walk={}, attack={}, heal={}, die={}, scale = 0.7  }, --boss2
            { walk={}, attack={}, heal={}, die={}, scale = 0.7  }, --boss3
            { walk={}, attack={}, heal={}, die={}, scale = 0.7  }  --boss4
          }
}

local obstacles = {}

local function getRandomWeaponForEnemy(tier)
    local hasWeaponChance = 0.5
    
    if math.random() > hasWeaponChance then
        return { hasWeapon = false, weapon = nil }
    end

    local tierWeapons = WeaponsByTier[tier] or {"bottle"}
    local assignedWeapon = tierWeapons[math.random(1, #tierWeapons)]

    return { hasWeapon = true, weapon = assignedWeapon }
end

local function chooseTypeMovement(animations, equipment, tier)
    if tier == 5 then
        if NextBossWeaponIndex == 1 then
            animations.walk = animation.new("assets/sprites/enemies/boss1/boss1_walk.png", 41, 61, 0.25, false)
            animations.attack = animation.new("assets/sprites/enemies/boss1/boss1_attack.png", 63, 56, 0.15, false)
            animations.heal = animation.new("assets/sprites/enemies/boss1/boss1_healthing.png", 59, 64, 0.15, false)
            animations.die = animation.new("assets/sprites/enemies/boss1/boss1_dead.png", 59, 62, 0.4, false)

        elseif NextBossWeaponIndex == 2 then
            animations.walk = animation.new("assets/sprites/enemies/boss1/boss1_walk.png", 41, 61, 0.25, false)
            animations.attack = animation.new("assets/sprites/enemies/boss1/boss1_attack.png", 63, 56, 0.15, false)
            animations.heal = animation.new("assets/sprites/enemies/boss1/boss1_healthing.png", 59, 64, 0.15, false)
            animations.die = animation.new("assets/sprites/enemies/boss1/boss1_dead.png", 59, 62, 0.4, false)

        elseif NextBossWeaponIndex == 3 then
            animations.walk = animation.new("assets/sprites/enemies/boss1/boss1_walk.png", 41, 61, 0.25, false)
            animations.attack = animation.new("assets/sprites/enemies/boss1/boss1_attack.png", 63, 56, 0.15, false)
            animations.heal = animation.new("assets/sprites/enemies/boss1/boss1_healthing.png", 59, 64, 0.15, false)
            animations.die = animation.new("assets/sprites/enemies/boss1/boss1_dead.png", 59, 62, 0.4, false)
        
        elseif NextBossWeaponIndex == 4 then
            animations.walk = animation.new("assets/sprites/enemies/boss1/boss1_walk.png", 41, 61, 0.25, false)
            animations.attack = animation.new("assets/sprites/enemies/boss1/boss1_attack.png", 63, 56, 0.15, false)
            animations.heal = animation.new("assets/sprites/enemies/boss1/boss1_healthing.png", 59, 64, 0.15, false)
            animations.die = animation.new("assets/sprites/enemies/boss1/boss1_dead.png", 59, 62, 0.4, false)
        end
    else
        if equipment.hasWeapon then
            if equipment.weapon == "bottle" then
                animations.walk = animation.new("assets/sprites/enemies/oldman/oldman_walk_40x60-250.png", 40, 60, 0.25, false)
                animations.attack = animation.new("assets/sprites/enemies/oldman/attacks/oldman_weapon_60x59-100.png", 60, 59, 0.33, false)
                animations.sweepKick = animation.new("assets/sprites/enemies/oldman/attacks/oldman_sweepKick_48x59-150.png", 48, 59, 0.33, false)
                animations.heal = animation.new("assets/sprites/enemies/oldman/oldman_healthing_57x62-200.png", 57, 62, 0.2, false)
                animations.die = animation.new("assets/sprites/enemies/oldman/oldman_dead_62x59-250.png", 62, 59, 0.25, false)

            elseif equipment.weapon == "knife" then
                animations.walk = animation.new("assets/sprites/enemies/oldman/oldman_walk_40x60-250.png", 40, 60, 0.25, false)
                animations.attack = animation.new("assets/sprites/enemies/oldman/attacks/oldman_weapon_60x59-100.png", 60, 59, 0.3, false)
                animations.sweepKick = animation.new("assets/sprites/enemies/oldman/attacks/oldman_sweepKick_48x59-150.png", 48, 59, 0.3, false)
                animations.heal = animation.new("assets/sprites/enemies/oldman/oldman_healthing_57x62-200.png", 57, 62, 0.2, false)
                animations.die = animation.new("assets/sprites/enemies/oldman/oldman_dead_62x59-250.png", 62, 59, 0.25, false)

            elseif equipment.weapon == "bat" then
                animations.walk = animation.new("assets/sprites/enemies/oldman/oldman_walk_40x60-250.png", 40, 60, 0.25, false)
                animations.attack = animation.new("assets/sprites/enemies/oldman/attacks/oldman_weapon_60x59-100.png", 60, 59, 0.3, false)
                animations.sweepKick = animation.new("assets/sprites/enemies/oldman/attacks/oldman_sweepKick_48x59-150.png", 48, 59, 0.33, false)
                animations.heal = animation.new("assets/sprites/enemies/oldman/oldman_healthing_57x62-200.png", 57, 62, 0.2, false)
                animations.die = animation.new("assets/sprites/enemies/oldman/oldman_dead_62x59-250.png", 62, 59, 0.25, false)

            elseif equipment.weapon == "wrench" then
                animations.walk = animation.new("assets/sprites/enemies/oldman/oldman_walk_40x60-250.png", 40, 60, 0.25, false)
                animations.attack = animation.new("assets/sprites/enemies/oldman/attacks/oldman_weapon_60x59-100.png", 60, 59, 0.33, false)
                animations.sweepKick = animation.new("assets/sprites/enemies/oldman/attacks/oldman_sweepKick_48x59-150.png", 48, 59, 0.33, false)
                animations.heal = animation.new("assets/sprites/enemies/oldman/oldman_healthing_57x62-200.png", 57, 62, 0.2, false)
                animations.die = animation.new("assets/sprites/enemies/oldman/oldman_dead_62x59-250.png", 62, 59, 0.25, false)
            end

            animations.commonWeaponAttack = animation.new("assets/sprites/enemies/oldman/attacks/oldman_weapon_60x59-100.png", 60, 59, 0.33, false)
        else
            animations.walk = animation.new("assets/sprites/enemies/oldman/oldman_walk_40x60-250.png", 40, 60, 0.25, false)
            animations.heal = animation.new("assets/sprites/enemies/oldman/oldman_healthing_57x62-200.png", 57, 62, 0.2, false)
            animations.die = animation.new("assets/sprites/enemies/oldman/oldman_dead_62x59-250.png", 62, 59, 0.25, false)
            animations.jabAttack = animation.new("assets/sprites/enemies/oldman/attacks/oldman_jab_64x59-150.png", 64, 59, 0.5, false)
            animations.comboAttack = animation.new("assets/sprites/enemies/oldman/attacks/oldman_combo_64x58-150.png", 64, 58, 0.4, false)
            animations.sweepKick = animation.new("assets/sprites/enemies/oldman/attacks/oldman_sweepKick_48x59-150.png", 48, 59, 0.33, false)
            animations.groundSlam = animation.new("assets/sprites/enemies/oldman/attacks/oldman_groundSlam_61x63-150.png", 61, 63, 0.4, false)
            animations.heavySmash = animation.new("assets/sprites/enemies/oldman/attacks/oldman_heavySmash_49x64-150.png", 49, 64, 0.33, false)
        end
    end

    return animations.walk
end

function Enemy.new(tier, _x, _y)

    
    local equipment
    if tier ~= 5 then
        equipment = getRandomWeaponForEnemy(tier)
        print(tostring(equipment.hasWeapon) .. ": " .. tostring(equipment.weapon))
    end

    local instance = {}
        instance.HP = mathUtils.calculateLife(tier)
        instance.maxHP = mathUtils.calculateLife(tier)
        instance.tier = tier --estas usando el digito de esta variable, tomar precauciones si decides cambiarlo a letras
        instance.isDead = false
        instance.animationDie = false
        instance.deathTimer = 1
        instance.x = _x
        instance.y = _y
        instance.speed = 150
        if tier == 5 then instance.width = dimensions[tier][NextBossWeaponIndex].walk[1] else instance.width = dimensions[tier].walk[1] end
        if tier == 5 then instance.height = dimensions[tier][NextBossWeaponIndex].walk[2] else instance.height = dimensions[tier].walk[2] end
        instance.direction = 1
        instance.patrolTimer = 0
        instance.isHealing = false
        instance.attackCooldown = 0
        if tier == 5 then instance.scale = (love.graphics.getWidth() / 256) * dimensions[tier][NextBossWeaponIndex].scale
        else instance.scale = (love.graphics.getWidth() / 256) * dimensions[tier].scale end
        if tier == 5 then instance.frameWidth = dimensions[tier][NextBossWeaponIndex].walk[1] else instance.frameWidth = dimensions[tier].walk[1] end
        if tier == 5 then instance.frameHeight = dimensions[tier][NextBossWeaponIndex].walk[2] else instance.frameHeight = dimensions[tier].walk[2] end
        instance.facingLeft = false
        instance.isMoving = true
        instance.animations = {}
        instance.currentAnimation = chooseTypeMovement(instance.animations, equipment, tier)
        instance.entityStatus = {
            statusType = "none",
            statusTimer = 0,
        }

    if tier == 5 then
        instance.createEnemies = false
        instance.hasWeapon = true
        if NextBossWeaponIndex <= 4 then instance.weapon = WeaponsByTier[4][NextBossWeaponIndex] end

        if NextBossWeaponIndex > #WeaponsByTier[4] then
            NextBossWeaponIndex = 1
        end
    else
        instance.hasWeapon = equipment.hasWeapon
        instance.weapon = equipment.weapon
    end

    EnemyCollisionBox.create(instance, "bottom")

    setmetatable(instance, Enemy)

    instance.tree = EnemyLogic.createTree()

    return instance
end

function Enemy:update(dt, player, obs)

    self:handleDeathTimer(dt)

    obstacles = obs

    self.tree:evaluate(self, dt)

    if self.currentAnimation then
        animation.update(self.currentAnimation, self.isMoving, dt)
    end

    entityStateSystem.updateStatus(player, dt, self, obstacles)
end

function Enemy:draw()
    
    love.graphics.setColor(0,1,0)
    love.graphics.rectangle("fill", self.x, self.y - 50, mathUtils.calculateHealthBarWidth(self.HP, self.maxHP), 15)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", self.x, self.y - 50, 100, 15)
    love.graphics.print(self.HP, self.x, self.y - 73, 0, 0.7)

    local quad = animation.getQuad(self.currentAnimation)

    if not quad then
        return
    end
    
    local sheet = animation.getSheet(self.currentAnimation)

    if self.facingLeft then
        love.graphics.draw(sheet, quad, self.x + self.scale * self.frameWidth,
        self.y, 0, - self.scale, self.scale)
    else
        love.graphics.draw(sheet, quad, self.x, self.y, 0,
        self.scale, self.scale)
    end

end

function Enemy:selectDimensions(anim)
    if not dimensions or not dimensions[self.tier] then
        self:setAnimation(anim)
        return
    end

    local data = nil

    if self.tier == 5 then
        local bossTable = dimensions[self.tier][NextBossWeaponIndex]
        if bossTable then
            data = bossTable[anim]
        end
    else
        data = dimensions[self.tier][anim]
    end

    if data and type(data) == "table" and data[1] and data[2] then
        self.width = data[1]
        self.height = data[2]
    else
        print("Advertencia: No se encontraron dimensiones para: " .. tostring(anim))
    end

    self:setAnimation(anim)
end

local function checkAnimation(self, anim)
    if self.isDead then
        self:selectDimensions("die")
    else
        self:selectDimensions(anim)
    end
end

function Enemy:setAnimation(animName)
    local newAnimation = self.animations[animName]
    if newAnimation and self.currentAnimation ~= newAnimation then
        self.currentAnimation = newAnimation
    end
end

-- definicion de ataques sin armas
function Enemy:jabAttack(dt, player)

    if self:hitTimer(dt, player, 2) then
        player.HP = player.HP - baseDamage.jabAttack * multipliers[self.tier]
        print("jab: ".. baseDamage.jabAttack * multipliers[self.tier])

        checkAnimation(self, "jabAttack")
    end
end

function Enemy:comboAttack(dt, player)
    if self:hitTimer(dt, player, 2) then
        player.HP = player.HP - baseDamage.comboAttack * multipliers[self.tier]
        print("combo: ".. baseDamage.comboAttack * multipliers[self.tier])

        checkAnimation(self, "comboAttack")
    end
end

function Enemy:sweepKick(dt, player)
    if self:hitTimer(dt, player, 2) then
        player.HP = player.HP - baseDamage.sweepKick * multipliers[self.tier]
        print("kick: ".. baseDamage.sweepKick * multipliers[self.tier])

        checkAnimation(self, "sweepKick")
    end
end

function Enemy:groundSlam(dt, player)
    if self:hitTimer(dt, player, 2) then
        player.HP = player.HP - baseDamage.groundSlam * multipliers[self.tier]
        print("slam: ".. baseDamage.groundSlam * multipliers[self.tier])

        entityStateSystem.applyStatusToTarget(player, entitiesStates[2].state, entitiesStates[2].duration)

        checkAnimation(self, "groundSlam")
    end
end

function Enemy:heavySmash(dt, player)
    if self:hitTimer(dt, player, 2) then
        player.HP = player.HP - baseDamage.heavySmash * multipliers[self.tier]
        print("heavy smash: "..  baseDamage.heavySmash * multipliers[self.tier])

        checkAnimation(self, "heavySmash")
    end
end

function Enemy:specialAttackBoss(dt, player)
    if self:hitTimer(dt, player, 2) then
        player.HP = player.HP - baseDamage.specialBatAttack * multipliers[3]
        print("special attack boss: ".. baseDamage.specialBatAttack * multipliers[3])

        checkAnimation(self, "attack")
    end
end

-- definicion de ataques con armas
function Enemy:commonWeaponAttack(dt, player)
    if self:hitTimer(dt, player, 2) then
        player.HP = player.HP - baseDamage.commonWeaponAttack * multipliers[self.tier]
        print("common weapon attack: ".. baseDamage.commonWeaponAttack * multipliers[self.tier])

        if self.animations.commonWeaponAttack then
            self:setAnimation("commonWeaponAttack")
        end
    end
end

function Enemy:specialBottleAttack(dt, player)
    if self:hitTimer(dt, player, 2) then
        if self.tier == 5 then
            player.HP = player.HP - baseDamage.specialBottleAttack * multipliers[self.tier][NextBossWeaponIndex]
            print("special bottle: ".. baseDamage.specialBottleAttack * multipliers[self.tier][NextBossWeaponIndex])
    
        else
            player.HP = player.HP - baseDamage.specialBottleAttack * multipliers[self.tier]
            print("special bottle: ".. baseDamage.specialBottleAttack * multipliers[self.tier])
        end
 
        entityStateSystem.applyStatusToTarget(player, entitiesStates[3].state, entitiesStates[3].duration)

        if self.animations.attack then
            self:setAnimation("attack")
        end
    end
end

function Enemy:specialKnifeAttack(dt, player)
    if self:hitTimer(dt, player, 2) then
        if self.tier == 5 then
            player.HP = player.HP - baseDamage.specialKnifeAttack * multipliers[self.tier][NextBossWeaponIndex]
            print("special knife: ".. baseDamage.specialKnifeAttack * multipliers[self.tier][NextBossWeaponIndex])
        
        else
            player.HP = player.HP - baseDamage.specialKnifeAttack * multipliers[self.tier]
            print("special knife: ".. baseDamage.specialKnifeAttack * multipliers[self.tier])
        end

        entityStateSystem.applyStatusToTarget(player, entitiesStates[4].state, entitiesStates[4].duration)

        if self.animations.attack then
            self:setAnimation("attack")
        end 
    end
end

function Enemy:specialBatAttack(dt, player)
    if self:hitTimer(dt, player, 2) then 
        if self.tier == 5 then
            player.HP = player.HP - baseDamage.specialBatAttack * multipliers[self.tier][NextBossWeaponIndex]
            print("special bat: ".. baseDamage.specialBatAttack * multipliers[self.tier][NextBossWeaponIndex])
        else
            player.HP = player.HP - baseDamage.specialBatAttack * multipliers[self.tier]
            print("special bat: ".. baseDamage.specialBatAttack * multipliers[self.tier])
        end

        entityStateSystem.applyStatusToTarget(player, entitiesStates[1].state, entitiesStates[1].duration)

        if self.animations.attack then
            self:setAnimation("attack")
        end
    end
end

function Enemy:specialWrenchAttack(dt, player)
    if self:hitTimer(dt, player, 2) then
        if self.tier == 5 then
            player.HP = player.HP - baseDamage.specialWrenchAttack * multipliers[self.tier][NextBossWeaponIndex]
            print("special wrench: ".. baseDamage.specialWrenchAttack * multipliers[self.tier][NextBossWeaponIndex])
        else
            player.HP = player.HP - baseDamage.specialWrenchAttack * multipliers[self.tier]
            print("special wrench: ".. baseDamage.specialWrenchAttack * multipliers[self.tier])
        end

        entityStateSystem.applyStatusToTarget(player, entitiesStates[2].state, entitiesStates[2].duration)

        if self.animations.attack then
            self:setAnimation("attack")
        end
    end
end


-- definicion de acciones de movimiento y estado

function Enemy:move(dt, XorY, direction, factorSpeed, setback)

    local cb = require("src.scripts.systems.collision_box")

    checkAnimation(self, "walk")

    if not self.isDead then
        if XorY == "x" then

            if direction == "left" then
                self.x = math.max(self.x - dt * self.speed * factorSpeed * setback, 0)
            elseif direction == "right" then
                self.x = self.x + dt * self.speed * factorSpeed * setback
            end

            self.updateCollisionBox()

            --Resolver x
            for _, obs in ipairs(obstacles) do
                if cb.check(self, obs) then
                    cb.resolveX(self, obs)
                end
            end
        
        elseif XorY == "y" then

            if direction == "up" then
                self.y = math.min(math.max(self.y - dt * self.speed * factorSpeed * setback, 0), love.graphics.getHeight() - self.scale * self.height)
            elseif direction == "down" then
                self.y = math.min(self.y + dt * self.speed * factorSpeed * setback, love.graphics.getHeight() - self.scale * self.height)
            end

            self.updateCollisionBox()

            --Resolver y
            for _, obs in ipairs(obstacles) do
                if cb.check(self, obs) then
                    cb.resolveY(self, obs)
                end
            end
        end
    end
end

function Enemy:stateFlee(dt, player)
    local distance = self:getDistanceToPlayer(player)
    local safe_distance = 400

    if self.isHealing and player.attacking then
        self.isHealing = false
    end

    self.isMoving = true

    if distance < safe_distance and not self.isHealing then

        if player.x < self.x then self.facingLeft = false else self.facingLeft = true end

        if self.x < player.x then self:move(dt, "x", "left", 0.8, 1) else self:move(dt, "x", "right", 0.8, 1) end
        if self.y < player.y then self:move(dt, "y", "up", 0.8, 1) else self:move(dt, "y", "down", 0.8, 1) end

    else
        self.isHealing = true
        
        checkAnimation(self, "heal")

        self.HP = self.HP + (10 * dt * self.tier)

        if self.HP >= self.maxHP * 0.4 then
            self.isHealing = false
        end
    end
end

function Enemy:statePatrol(dt)

    if self.direction < 0 then self.facingLeft = true else self.facingLeft = false end

    self.isMoving = true
    self.patrolTimer = self.patrolTimer + dt

    if self.patrolTimer > 3 then
        self.direction = self.direction * -1
        self.patrolTimer = 0
        self.facingLeft = not self.facingLeft
    end

    if self.direction < 0 then self:move(dt, "x", "left", 0.5, 1) else self:move(dt, "x", "right", 0.5, 1) end
end

function Enemy:getDistanceToPlayer(player)

    local dx = self.x - player.x
    local dy = self.y - player.y
    local distance = math.sqrt(dx^2 + dy^2)
    self.currentDistDebug = distance
    
    return distance
end

function Enemy:chaseTarget(dt, player)
    local minDistance = 75

    local dx = player.x - self.x
    local dy = player.y - self.y
    local distance = math.sqrt(dx^2 + dy^2)

    if player.x < self.x then 
        self.facingLeft = true 
    else 
        self.facingLeft = false 
    end

    self.isMoving = true

    if distance > minDistance then
        local dirX = dx / distance
        local dirY = dy / distance

        -- Movimiento hacia el jugador
        self:move(dt, "x", "right", 0.9, dirX)
        self:move(dt, "y", "down", 0.9, dirY)

        return false

    elseif distance <= (minDistance - 5) then
        local dirX = dx / distance
        local dirY = dy / distance

        -- Retroceso si está demasiado cerca del player
        self:move(dt, "x", "left", 0.9, dirX)
        self:move(dt, "y", "up", 0.9, dirY)

        return true
    else
        return true
    end
end

function Enemy:hitTimer(dt, player, duration)
    if self:chaseTarget(dt, player) then
        if self.attackCooldown > 0 then
            self.attackCooldown = self.attackCooldown - dt

            return false
        end

        if self.attackCooldown <= 0 then
            self.attackCooldown = duration

            player.isHurt = true
            player.hurtTimer = 0.10

            return true
        end
    end
end

function Enemy:handleDeathTimer(dt)
    if self.isDead and not self.animationDie then
        if self.deathTimer > 0 then
            self.deathTimer = self.deathTimer - dt
        else
            self.deathTimer = 0
            self.animationDie = true
        end
    end
end

function Enemy:dropItem(items)
    local item = require("src.scripts.entities.item")

    local itemY = (self.collisionBox.y + self.collisionBox.height) / scale

    if itemY >= love.graphics.getHeight() / scale then
        itemY = self.collisionBox.y / scale
    end

    local itm = item.new(self.weapon, self.x/scale, itemY)

    if itm then
        table.insert(items, itm)
    end
end

function Enemy:getSpecialProbability()
    local baseProbabilities = {0.15, 0.20, 0.25, 0.30}
    local prob = baseProbabilities[self.tier] or 0.15
    
    if self.weapon == "bat" or self.weapon == "wrench" then
        prob = prob - 0.05
    elseif self.weapon == "bottle" or self.weapon == "knife" then
        prob = prob + 0.05
    end
    
    if self.HP and self.HP < self.maxHP * 0.20 then
        prob = prob + 0.05
    end

    return math.max(0.0, math.min(1.0, prob))
end

return Enemy