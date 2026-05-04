local Enemy = {}
Enemy.__index = Enemy
local EnemyCollisionBox = require("src.scripts.systems.collision_box")
local EnemyLogic = require("src.scripts.logic.enemy_logic")
local mathUtils = require("src.scripts.utils.mathUtils")
local entityStateSystem = require("src.scripts.systems.entity_state_system")

local scale = love.graphics.getWidth() / 256

local WeaponsByTier = {
    [1] = {"bottle"},
    [2] = {"bottle", "knife"},
    [3] = {"bottle", "knife", "bat"},
    [4] = {"bottle", "knife", "bat", "wrench"}
}

local entitiesStates = {
    {state = "knockback", duration = 1},
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
    [4] = 1.8
}

local function getRandomWeaponForEnemy(tier)
    local hasWeaponChance = 0.5
    
    if math.random() > hasWeaponChance then
        return { hasWeapon = false, weapon = nil }
    end

    local tierWeapons = WeaponsByTier[tier] or {"bottle"}
    local assignedWeapon = tierWeapons[math.random(1, #tierWeapons)]

    return { hasWeapon = true, weapon = assignedWeapon }
end

function Enemy.new(tier, _x, _y, _width, _height, boxW, boxH)

    local equipment = getRandomWeaponForEnemy(tier)

    print(equipment.hasWeapon)
    local instance = {}
        instance.HP = mathUtils.calculateLife(tier)
        instance.maxHP = mathUtils.calculateLife(tier)
        instance.tier = tier --estas usando el digito de esta variable, tomar precauciones si decides cambiarlo a letras
        instance.isDead = false
        instance.x = _x
        instance.y = _y
        instance.speed = 150
        instance.enemyWidth = _width
        instance.enemyHeight = _height
        instance.hasWeapon = equipment.hasWeapon
        instance.weapon = equipment.weapon
        instance.width = boxW
        instance.height = boxH
        instance.currentColor = {0,0,1}
        instance.direction = 1
        instance.patrolTimer = 0
        instance.isHealing = false
        instance.attackCooldown = 0

        instance.entityStatus = {
            statusType = "none",
            statusTimer = 0,
        }

    EnemyCollisionBox.create(instance, "bottom")

    setmetatable(instance, Enemy)

    instance.tree = EnemyLogic.createTree()

    return instance
end

function Enemy:update(dt, player)
    self.tree:evaluate(self, dt)

    entityStateSystem.updateStatus(player, dt, self)
end

function Enemy:draw()
    
    love.graphics.setColor(self.currentColor)
    love.graphics.rectangle("fill", self.x, self.y, self.enemyWidth, self.enemyHeight)
    
    love.graphics.setColor(0,1,0)
    love.graphics.rectangle("fill", self.x, self.y - 50, mathUtils.calculateHealthBarWidth(self.HP, self.maxHP), 15)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", self.x, self.y - 50, 100, 15)
    love.graphics.print(self.HP, self.x, self.y - 73, 0, 0.7)

end

-- definicion de ataques sin armas
function Enemy:jabAttack(dt, player)

    if self:hitTimer(dt, player) then
        player.HP = player.HP - baseDamage.jabAttack * multipliers[self.tier]
        print("jab: ".. baseDamage.jabAttack * multipliers[self.tier])

    end
end

function Enemy:comboAttack(dt, player)
    if self:hitTimer(dt, player) then
        player.HP = player.HP - baseDamage.comboAttack * multipliers[self.tier]
        print("combo: ".. baseDamage.comboAttack * multipliers[self.tier])
        
    end
end

function Enemy:sweepKick(dt, player)
    if self:hitTimer(dt, player) then
        player.HP = player.HP - baseDamage.sweepKick * multipliers[self.tier]
        print("kick: ".. baseDamage.sweepKick * multipliers[self.tier])

        entityStateSystem.applyStatusToTarget(player, entitiesStates[1].state, entitiesStates[1].duration)

    end
end

function Enemy:groundSlam(dt, player)
    if self:hitTimer(dt, player) then
        player.HP = player.HP - baseDamage.groundSlam * multipliers[self.tier]
        print("slam: ".. baseDamage.groundSlam * multipliers[self.tier])

        entityStateSystem.applyStatusToTarget(player, entitiesStates[2].state, entitiesStates[2].duration)

    end
end

function Enemy:heavySmash(dt, player)
    if self:hitTimer(dt, player) then
        player.HP = player.HP - baseDamage.heavySmash * multipliers[self.tier]
        print("heavy smash: "..  baseDamage.heavySmash * multipliers[self.tier])

    end
end

function Enemy:specialAttackBoss(dt, player)
    if self:hitTimer(dt, player) then
        player.HP = player.HP - 500 -- falta implementar
        print("special")

    end
end

-- definicion de ataques con armas
function Enemy:commonWeaponAttack(dt, player)
    if self:hitTimer(dt, player) then
        player.HP = player.HP - baseDamage.commonWeaponAttack * multipliers[self.tier]
        print("common weapon attack: ".. baseDamage.commonWeaponAttack * multipliers[self.tier])

    end
end

function Enemy:specialBottleAttack(dt, player)
    if self:hitTimer(dt, player) then
        player.HP = player.HP - baseDamage.specialBottleAttack * multipliers[self.tier]
        print("special bottle: ".. baseDamage.specialBottleAttack * multipliers[self.tier])
        
        entityStateSystem.applyStatusToTarget(player, entitiesStates[3].state, entitiesStates[3].duration)

    end
end
function Enemy:specialKnifeAttack(dt, player)
    if self:hitTimer(dt, player) then
        player.HP = player.HP - baseDamage.specialKnifeAttack * multipliers[self.tier]
        print("special knife: " ..baseDamage.specialKnifeAttack * multipliers[self.tier])
        
        entityStateSystem.applyStatusToTarget(player, entitiesStates[4].state, entitiesStates[4].duration)

    end
end
function Enemy:specialBatAttack(dt, player)
    if self:hitTimer(dt, player) then
        player.HP = player.HP - baseDamage.specialBatAttack * multipliers[self.tier]
        print("special bat: ".. baseDamage.specialBatAttack * multipliers[self.tier])
        
        entityStateSystem.applyStatusToTarget(player, entitiesStates[1].state, entitiesStates[1].duration)

    end
end
function Enemy:specialWrenchAttack(dt, player)
    if self:hitTimer(dt, player) then
        player.HP = player.HP - baseDamage.specialWrenchAttack * multipliers[self.tier]
        print("special wrench: "..baseDamage.specialWrenchAttack * multipliers[self.tier])
        
        entityStateSystem.applyStatusToTarget(player, entitiesStates[2].state, entitiesStates[2].duration)

    end
end


-- definicion de acciones de movimiento y estado
function Enemy:stateFlee(dt, player)
    local distance = self:getDistanceToPlayer(player)
    local safe_distance = 500

    if distance < safe_distance and not self.isHealing then
        local flee_speed = self.speed * 0.9
        if self.x < player.x then self.x = self.x - flee_speed * dt else self.x = self.x + flee_speed * dt end
        if self.y < player.y then self.y = self.y - flee_speed * dt else self.y = self.y + flee_speed * dt end
        
        self.currentColor = {1, 1, 0}
    else
        self.isHealing = true
        self.currentColor = {0, 1, 0}
                
        self.HP = self.HP + (10 * dt * self.tier)

        if self.HP >= self.maxHP * 0.4 then
            self.isHealing = false
            print("hola bebe")
        end
    end
end

function Enemy:statePatrol(dt)
    self.patrolTimer = self.patrolTimer + dt

    if self.patrolTimer > 3 then
        self.direction = self.direction * -1
        self.patrolTimer = 0
    end

    self.x = self.x + (self.speed * 0.5 * self.direction * dt)
    
    self.currentColor = {0,0,1}

end

function Enemy:getDistanceToPlayer(player)

    local dx = self.x - player.x
    local dy = self.y - player.y
    local distance = math.sqrt(dx^2 + dy^2)
    self.currentDistDebug = distance
    
    return distance
end

function Enemy:chaseTarget(dt, player)
    local attackSpeed = self.speed * 0.9
    local minDistance = 75

    local dx = player.x - self.x
    local dy = player.y - self.y
    local distance = math.sqrt(dx^2 + dy^2)

    self.currentColor = {1,0,0}

    if distance > minDistance then
        local dirX = dx / distance
        local dirY = dy / distance

        self.x = self.x + dirX * attackSpeed * dt
        self.y = self.y + dirY * attackSpeed * dt

        return false

    elseif distance <= (minDistance - 5) then
        local dirX = dx / distance
        local dirY = dy / distance

        self.x = self.x - dirX * (attackSpeed * 0.5) * dt
        self.y = self.y - dirY * (attackSpeed * 0.5) * dt

        return true

    else
        return true
    end
end

function Enemy:hitTimer(dt, player)
    if self:chaseTarget(dt, player) then
        if self.attackCooldown > 0 then
            self.attackCooldown = self.attackCooldown - dt

            return false
        end

        if self.attackCooldown <= 0 then
            self.currentColor = {1, 0, 0}
            self.attackCooldown = 2

            player.isHurt = true
            player.hurtTimer = 0.10

            return true
        end
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