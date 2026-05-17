local entitiesData = {}

function entitiesData.generateFixedObstacles(blockNumber, obstacle, obstaclesTable)
    local sprites = {
        cono = { img = love.graphics.newImage("assets/sprites/items/cono.png"), w = 51, h = 64, col = "bottom" },
        stone = { img = love.graphics.newImage("assets/sprites/items/heavyStone.png"), w = 64, h = 53, col = "bottom" },
        wheel = { img = love.graphics.newImage("assets/sprites/items/wheel.png"), w = 58, h = 42, col = "bottom" }
    }

    -- BLOQUE 1: Rango X de 500 a 5500 (24 Obstáculos)
    if blockNumber == 1 then
        local data = {
            { x = 20,   y = 85,  t = "cono" },  { x = 80,   y = 105, t = "stone" }, { x = 140,  y = 95,  t = "wheel" },
            { x = 200,  y = 85,  t = "stone" }, { x = 260,  y = 95, t = "cono" },  { x = 320,  y = 90,  t = "wheel" },
            { x = 380,  y = 115, t = "stone" }, { x = 440,  y = 80,  t = "wheel" }, { x = 500,  y = 100, t = "cono" },
            { x = 560,  y = 75,  t = "cono" },  { x = 620,  y = 110, t = "stone" }, { x = 680,  y = 90,  t = "wheel" },
            { x = 740,  y = 105, t = "stone" }, { x = 800,  y = 90,  t = "cono" },  { x = 860,  y = 115, t = "wheel" },
            { x = 920,  y = 75,  t = "cono" },  { x = 980,  y = 100, t = "stone" }, { x = 1040, y = 90,  t = "wheel" },
            { x = 1100, y = 110, t = "stone" }, { x = 1160, y = 80,  t = "cono" },  { x = 1220, y = 105, t = "wheel" },
            { x = 1280, y = 85,  t = "stone" }, { x = 1340, y = 110, t = "cono" },  { x = 1390, y = 95,  t = "wheel" }
        }
        for _, obs in ipairs(data) do
            local s = sprites[obs.t]
            local newObs = obstacle.new(true, obs.x, obs.y, s.w, s.h, s.col, s.img, false, 0.5)
            table.insert(obstaclesTable, newObs)
        end

    -- BLOQUE 2: Rango X de 6000 a 10000 (20 Obstáculos)
    elseif blockNumber == 2 then
        local data = {
            { x = 1460, y = 85,  t = "wheel" }, { x = 1495, y = 110, t = "stone" }, { x = 1530, y = 75,  t = "cono" },
            { x = 1565, y = 100, t = "stone" }, { x = 1600, y = 90,  t = "wheel" }, { x = 1635, y = 115, t = "cono" },
            { x = 1670, y = 95,  t = "stone" }, { x = 1705, y = 105, t = "cono" },  { x = 1740, y = 95,  t = "wheel" },
            { x = 1775, y = 75,  t = "stone" }, { x = 1810, y = 110, t = "wheel" }, { x = 1845, y = 100, t = "cono" },
            { x = 1880, y = 85,  t = "stone" }, { x = 1915, y = 115, t = "wheel" }, { x = 1950, y = 90,  t = "cono" },
            { x = 1985, y = 75,  t = "stone" }, { x = 2020, y = 105, t = "cono" },  { x = 2055, y = 100, t = "wheel" },
            { x = 2090, y = 80,  t = "stone" }, { x = 2125, y = 115, t = "cono" },
        }
        for _, obs in ipairs(data) do
            local s = sprites[obs.t]
            local newObs = obstacle.new(true, obs.x, obs.y, s.w, s.h, s.col, s.img, false, 0.5)
            table.insert(obstaclesTable, newObs)
        end

    -- BLOQUE 3: Rango X de 10500 a 12000 (7 Obstáculos)
    elseif blockNumber == 3 then
        local data = {
            { x = 2130, y = 80,  t = "stone" }, { x = 2155, y = 110, t = "cono" },  { x = 2180, y = 95,  t = "wheel" },
            { x = 2280, y = 90,  t = "stone" }, { x = 2305, y = 110, t = "cono" },  
            { x = 2240, y = 95,  t = "wheel" }, { x = 2360, y = 100, t = "stone" }
        }
        for _, obs in ipairs(data) do
            local s = sprites[obs.t]
            local newObs = obstacle.new(true, obs.x, obs.y, s.w, s.h, s.col, s.img, false, 0.5)
            table.insert(obstaclesTable, newObs)
        end
    
    elseif blockNumber == 4 then
        local data = {
            { x = 45,   y = 112, t = "wheel" }, { x = 95,   y = 78,  t = "cono" },  { x = 135,  y = 95,  t = "stone" },
            { x = 220,  y = 105, t = "wheel" }, { x = 285,  y = 82,  t = "stone" }, { x = 340,  y = 110, t = "cono" },
            { x = 410,  y = 76,  t = "wheel" }, { x = 465,  y = 92,  t = "cono" },  { x = 525,  y = 115, t = "stone" },
            { x = 580,  y = 100, t = "stone" }, { x = 645,  y = 85,  t = "wheel" }, { x = 700,  y = 108, t = "cono" },
            { x = 760,  y = 79,  t = "cono" },  { x = 825,  y = 114, t = "stone" }, { x = 885,  y = 90,  t = "wheel" },
            { x = 940,  y = 102, t = "wheel" }, { x = 1005, y = 75,  t = "stone" }, { x = 1060, y = 111, t = "cono" },
            { x = 1125, y = 88,  t = "stone" }, { x = 1180, y = 113, t = "cono" },  { x = 1245, y = 81,  t = "wheel" },
            { x = 1300, y = 96,  t = "cono" },  { x = 1355, y = 107, t = "wheel" }, { x = 1395, y = 77,  t = "stone" }
        }
        for _, obs in ipairs(data) do
            local s = sprites[obs.t]
            local newObs = obstacle.new(true, obs.x, obs.y, s.w, s.h, s.col, s.img, false, 0.5)
            table.insert(obstaclesTable, newObs)
        end
    
    elseif blockNumber == 5 then
        local data = {
            { x = 1470, y = 80,  t = "cono" },  { x = 1515, y = 112, t = "wheel" }, { x = 1545, y = 95,  t = "stone" },
            { x = 1585, y = 76,  t = "cono" },  { x = 1610, y = 105, t = "stone" }, { x = 1655, y = 88,  t = "wheel" },
            { x = 1680, y = 114, t = "cono" },  { x = 1725, y = 75,  t = "wheel" }, { x = 1750, y = 100, t = "stone" },
            { x = 1795, y = 90,  t = "stone" }, { x = 1820, y = 115, t = "cono" },  { x = 1865, y = 82,  t = "wheel" },
            { x = 1890, y = 108, t = "cono" },  { x = 1935, y = 77,  t = "stone" }, { x = 1960, y = 93,  t = "wheel" },
            { x = 2005, y = 111, t = "wheel" }, { x = 2030, y = 85,  t = "stone" }, { x = 2075, y = 102, t = "cono" },
            { x = 2100, y = 79,  t = "stone" }, { x = 2130, y = 113, t = "wheel" }
        }
        for _, obs in ipairs(data) do
            local s = sprites[obs.t]
            local newObs = obstacle.new(true, obs.x, obs.y, s.w, s.h, s.col, s.img, false, 0.5)
            table.insert(obstaclesTable, newObs)
        end
    
    elseif blockNumber == 6 then
        local data = {
            { x = 2130, y = 80,  t = "wheel" }, { x = 2165, y = 112, t = "stone" }, { x = 2205, y = 76,  t = "cono" },
            { x = 2240, y = 105, t = "wheel" }, { x = 2280, y = 90,  t = "stone" }, { x = 2320, y = 114, t = "cono" }, 
            { x = 2355, y = 75,  t = "wheel" }
        }
        for _, obs in ipairs(data) do
            local s = sprites[obs.t]
            local newObs = obstacle.new(true, obs.x, obs.y, s.w, s.h, s.col, s.img, false, 0.5)
            table.insert(obstaclesTable, newObs)
        end
    end
end

function entitiesData.generateItems(opcion, item, items)

    if opcion == 1 then
        local newArepas = { {x=2800, y=590}, {x=4500, y=610}, {x=6200, y=630}, {x=8000, y=685}, {x=9800, y=530}, {x=11500, y=605}, {x=12300, y=550} }
        for i, arepa in ipairs(newArepas) do
            local a = item.new("arepa", arepa.x, arepa.y)
            a.count = 1
            table.insert(items, a)
        end

    elseif opcion == 2 then
        local newArepas = { {x=1250, y=565}, {x=2900, y=665}, {x=4400, y=685}, {x=6100, y=605}, {x=8200, y=665}, {x=9700, y=585}, {x=11600, y=570} }
        for i, arepa in ipairs(newArepas) do
            local a = item.new("arepa", arepa.x, arepa.y)
            a.count = 1
            table.insert(items, a)
        end

    elseif opcion == 3 then
        local newArepas = { {x=1200, y=642}, {x=2750, y=558}, {x=4600, y=671}, {x=6300, y=604}, {x=8100, y=683}, {x=10900, y=579}, {x=12500, y=622} }
        for i, arepa in ipairs(newArepas) do
            local a = item.new("arepa", arepa.x, arepa.y)
            a.count = 1
            table.insert(items, a)
        end

    elseif opcion == 4 then
        local newArepas = { {x=1300, y=593}, {x=2850, y=664}, {x=4450, y=551}, {x=6150, y=618}, {x=8050, y=687}, {x=9650, y=572}, {x=11700, y=639} }
        for i, arepa in ipairs(newArepas) do
            local a = item.new("arepa", arepa.x, arepa.y)
            a.count = 1
            table.insert(items, a)
        end

    end
end

return entitiesData