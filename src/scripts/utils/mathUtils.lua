local mathUtils = {}

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
    return (HP*100)/maxHP
end

return mathUtils