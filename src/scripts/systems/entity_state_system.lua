local entityStateSystem = {}

function entityStateSystem.applyStatusToTarget(target, newStatus, duration)
    target.entityStatus.statusType = newStatus
    target.entityStatus.statusTimer = duration
end

entityStateSystem.statusDictionary = {
    -- Estado por defecto, no hace nada
    none = function(entity, dt) end,

    -- Estado de retroceso (Knockback)
    knockback = function(entity, dt, attacker, obstacles)

        local factorSpeed
        if attacker.tier and attacker.tier == 5 then factorSpeed = 5 else factorSpeed = 1.5 end

        local dx = entity.x - attacker.x
        local dy = entity.y - attacker.y
        local distance = math.sqrt(dx^2 + dy^2)

        if distance > 0 then
            if entity.x > attacker.x then
                entity.involuntaryMovement(dt, "x", "right", factorSpeed, 1, obstacles)
            else
                entity.involuntaryMovement(dt, "x", "left", factorSpeed, 1, obstacles)
            end

            if entity.y > attacker.y then
                entity.involuntaryMovement(dt, "y", "down", 1.2, 1, obstacles)
            else
                entity.involuntaryMovement(dt, "y", "up", 1.2, 1, obstacles)
            end
        
        end
    end,

    -- Estado de paralizar (Stun)
    stun = function(entity)
        if not entity.originalSpeed then
            entity.originalSpeed = entity.speed or 150
        end
        
        entity.speed = 0
        entity.isMoving = false
    end,

    -- Estado de ralentizar (Slow)  
    slow = function(entity)
        if not entity.originalSpeed then
            entity.originalSpeed = entity.speed or 150
        end

        local slowFactor = 0.5
        entity.speed = entity.originalSpeed * slowFactor
    end,

    bleed = function(entity, dt)

        if not entity.bleedTimer then
            entity.bleedTimer = 0
            entity.bleedInterval = 0.5
            entity.damagePerTick = 2
        end

        entity.bleedTimer = entity.bleedTimer + dt * 0.5

        if entity.bleedTimer >= entity.bleedInterval then
            entity.HP = entity.HP - entity.damagePerTick

            entity.isHurt = true
            entity.hurtTimer = 0.10
            
            entity.bleedTimer = entity.bleedTimer - entity.bleedInterval
        end
    end
}

function entityStateSystem.updateStatus(entity, dt, attacker, obstacles)
    if entity.entityStatus.statusType ~= "none" then

        if entity.entityStatus.statusTimer > 0 then

            entity.entityStatus.statusTimer = entity.entityStatus.statusTimer - dt
            
            local effectFunction = entityStateSystem.statusDictionary[entity.entityStatus.statusType]

            if effectFunction then
                effectFunction(entity, dt, attacker, obstacles)
            end

        else

            if (entity.entityStatus.statusType == "stun" or entity.entityStatus.statusType == "slow") then
                if entity.type == "player" then
                    entity.speed = 150
                else
                    entity.speed = 150
                end
                entity.originalSpeed = nil
                entity.isMoving = true
            end

            if entity.entityStatus.statusType == "bleed" then
                entity.bleedTimer = nil
                entity.bleedInterval = nil
                entity.damagePerTick = nil
            end

            entity.entityStatus.statusType = "none"
        end
    end
end

return entityStateSystem