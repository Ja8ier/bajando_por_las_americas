local Enemy = {}
Enemy.__index = Enemy
local EnemyCollisionBox = require("src.scripts.systems.collision_box")
local EnemyLogic = require("src.scripts.logic.enemy_logic")
local mathUtils = require("src.scripts.utils.mathUtils")

local scale = love.graphics.getWidth() / 256

function Enemy.new(tier, _x, _y, width, height, boxW, boxH)
    local instance = {}
    instance.HP = mathUtils.calculateLife(tier)
    instance.maxHP = mathUtils.calculateLife(tier)
    instance.tier = tier --estas usando el digito de esta variable, tomar precauciones si decides cambiarlo a letras
    instance.x = _x
    instance.y = _y
    instance.speed = 150
    instance.enemyWidth = width
    instance.enemyHeight = height
    instance.boxWidth = boxW
    instance.boxHeight = boxH
    instance.currentColor = {0,0,1}
    instance.direction = 1
    instance.patrolTimer = 0
    instance.isHealing = false
    instance.attackCooldown = 0
    love.graphics.setDefaultFilter("nearest", "nearest")

    EnemyCollisionBox.create(instance, "bottom")

    setmetatable(instance, Enemy)

    instance.tree = EnemyLogic.createTree(tier)

    return instance
end

function Enemy:update(dt)
    self.tree:evaluate(self, dt)
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

function Enemy:jabAttack(dt, player)

    if self:hitTimer(dt, player) then
        player.HP = player.HP - 100
        print("jab")
    end
end

function Enemy:comboAttack(dt, player)
    if self:hitTimer(dt, player) then
        player.HP = player.HP - 170
        print("combo")
    end
end

function Enemy:sweepKick(dt, player)
    if self:hitTimer(dt, player) then
        player.HP = player.HP - 80
        print("kick")
    end
end

function Enemy:groundSlam(dt, player)
    if self:hitTimer(dt, player) then
        player.HP = player.HP - 200
        print("slam")
    end
end

function Enemy:heavySmash(dt, player)
    if self:hitTimer(dt, player) then
        player.HP = player.HP - 250
        print("heavy smash")
    end
end

function Enemy:specialAttackBoss(dt, player)
    if self:hitTimer(dt, player) then
        player.HP = player.HP - 500
        print("special")
    end
end

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

            return true
        end
    end
end

return Enemy
