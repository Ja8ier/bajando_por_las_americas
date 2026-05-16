local obstacleData = {}

function obstacleData.generateFixedObstacles(blockNumber, obstacle, obstaclesTable)
    local sprites = {
        cono = { img = love.graphics.newImage("assets/sprites/items/cono.png"), w = 51, h = 64, col = "bottom" },
        stone = { img = love.graphics.newImage("assets/sprites/items/heavyStone.png"), w = 64, h = 53, col = "bottom" },
        wheel = { img = love.graphics.newImage("assets/sprites/items/wheel.png"), w = 58, h = 42, col = "bottom" }
    }

    -- BLOQUE 1: Rango X de 500 a 5500 (24 Obstáculos)
    if blockNumber == 1 then
        local data = {
            { x = 20,   y = 75,  t = "cono" },  { x = 65,   y = 115, t = "stone" }, { x = 110,  y = 90,  t = "wheel" },
            { x = 155,  y = 80,  t = "stone" }, { x = 200,  y = 110, t = "cono" },  { x = 245,  y = 95,  t = "wheel" },
            { x = 290,  y = 70,  t = "stone" }, { x = 335,  y = 120, t = "wheel" }, { x = 380,  y = 85,  t = "cono" },
            { x = 425,  y = 105, t = "cono" },  { x = 470,  y = 75,  t = "stone" }, { x = 515,  y = 115, t = "wheel" },
            { x = 560,  y = 90,  t = "stone" }, { x = 605,  y = 80,  t = "cono" },  { x = 650,  y = 110, t = "wheel" },
            { x = 695,  y = 95,  t = "cono" },  { x = 740,  y = 70,  t = "stone" }, { x = 785,  y = 120, t = "wheel" },
            { x = 830,  y = 85,  t = "stone" }, { x = 875,  y = 105, t = "cono" },  { x = 920,  y = 75,  t = "wheel" },
            { x = 965,  y = 115, t = "stone" }, { x = 1010, y = 90,  t = "cono" },  { x = 1055, y = 100, t = "wheel" }
        }
        for _, obs in ipairs(data) do
            local s = sprites[obs.t]
            local newObs = obstacle.new(true, obs.x, obs.y, s.w, s.h, s.col, s.img, false, 0.5)
            table.insert(obstaclesTable, newObs)
        end

    -- BLOQUE 2: Rango X de 6000 a 10000 (22 Obstáculos)
    elseif blockNumber == 2 then
        local data = {
            { x = 1160, y = 75,  t = "wheel" }, { x = 1195, y = 115, t = "stone" }, { x = 1230, y = 90,  t = "cono" },
            { x = 1265, y = 80,  t = "stone" }, { x = 1300, y = 110, t = "wheel" }, { x = 1335, y = 95,  t = "cono" },
            { x = 1370, y = 70,  t = "stone" }, { x = 1405, y = 120, t = "cono" },  { x = 1440, y = 85,  t = "wheel" },
            { x = 1475, y = 105, t = "stone" }, { x = 1510, y = 75,  t = "wheel" }, { x = 1545, y = 115, t = "cono" },
            { x = 1580, y = 90,  t = "stone" }, { x = 1615, y = 80,  t = "wheel" }, { x = 1650, y = 110, t = "cono" },
            { x = 1685, y = 95,  t = "stone" }, { x = 1720, y = 70,  t = "cono" },  { x = 1755, y = 120, t = "wheel" },
            { x = 1790, y = 85,  t = "stone" }, { x = 1825, y = 105, t = "cono" },  { x = 1860, y = 75,  t = "wheel" },
            { x = 1895, y = 110, t = "stone" }
        }
        for _, obs in ipairs(data) do
            local s = sprites[obs.t]
            local newObs = obstacle.new(true, obs.x, obs.y, s.w, s.h, s.col, s.img, false, 0.5)
            table.insert(obstaclesTable, newObs)
        end

    -- BLOQUE 3: Rango X de 10500 a 12000 (10 Obstáculos)
    elseif blockNumber == 3 then
        local data = {
            { x = 2010, y = 75,  t = "stone" }, { x = 2045, y = 115, t = "cono" },  { x = 2080, y = 90,  t = "wheel" },
            { x = 2115, y = 80,  t = "stone" }, { x = 2150, y = 110, t = "cono" },  { x = 2185, y = 95,  t = "wheel" },
            { x = 2220, y = 70,  t = "stone" }, { x = 2255, y = 120, t = "cono" },  { x = 2290, y = 85,  t = "wheel" },
            { x = 2340, y = 105, t = "stone" }
        }
        for _, obs in ipairs(data) do
            local s = sprites[obs.t]
            local newObs = obstacle.new(true, obs.x, obs.y, s.w, s.h, s.col, s.img, false, 0.5)
            table.insert(obstaclesTable, newObs)
        end
    end
end

return obstacleData