local entityStateSystem = {}

function entityStateSystem.applyStatusToTarget(target, newStatus, duration)
    target.entityStatus.statusType = newStatus
    target.entityStatus.statusTimer = duration
end

entityStateSystem.statusDictionary = {
    -- Estado por defecto, no hace nada
    none = function(entity, dt) end,

    -- Estado de retroceso (Knockback)
    knockback = function(entity, dt, attacker)

        local dx = entity.x - attacker.x
        local dy = entity.y - attacker.y
        local distance = math.sqrt(dx^2 + dy^2)

        if distance > 0 then
            local dirX = dx / distance
            local dirY = dy / distance
            
            local force = 160
            entity.x = entity.x + dirX * force * dt
            entity.y = entity.y + dirY * force * dt
        
        end
    end,

    -- Estado de paralizar (Stun)
    stun = function(entity, dt)
        if not entity.originalSpeed then
            entity.originalSpeed = entity.speed or 150
        end
        
        entity.speed = 0
    end,

    -- Estado de ralentizar (Slow)  
    slow = function(entity, dt)
        if not entity.originalSpeed then
            entity.originalSpeed = entity.speed or 150
        end

        local slowFactor = 0.5
        entity.speed = entity.originalSpeed * slowFactor
    end,

    bleed = function(entity, dt, attacker)

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

function entityStateSystem.updateStatus(entity, dt, attacker)
    if entity.entityStatus.statusType ~= "none" then

        if entity.entityStatus.statusTimer > 0 then

            entity.entityStatus.statusTimer = entity.entityStatus.statusTimer - dt
            
            local effectFunction = entityStateSystem.statusDictionary[entity.entityStatus.statusType]

            if effectFunction then
                effectFunction(entity, dt, attacker)
            end

        else

            if (entity.entityStatus.statusType == "stun" or entity.entityStatus.statusType == "slow") and entity.originalSpeed then
                entity.speed = entity.originalSpeed
                entity.originalSpeed = nil
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