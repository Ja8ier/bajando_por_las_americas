local mathUtils = {}
local scale = love.graphics.getWidth() / 256

local tierLifeValues = {
    [1] = 100,  -- Tier 1
    [2] = 250,  -- Tier 2
    [3] = 450,  -- Tier 3
    [4] = 750,  -- Tier 4
    [5] = 2500  -- Tier 5 (Boss)
}

function mathUtils.calculateLife(tier)
    return tierLifeValues[tier]
end

function mathUtils.calculateHealthBarWidth(HP, maxHP)

    if maxHP <= 0 then
        return 0
    end
    return (HP* 32 * scale)/maxHP
end

function mathUtils.getDistanceToPlayer(player, enemy)

    local dx = enemy.x - player.x
    local dy = enemy.y - player.y
    local distance = math.sqrt(dx^2 + dy^2)
    return distance
end


return mathUtils