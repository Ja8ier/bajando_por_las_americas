local minigame = {
    isWin = false
}

local minigames = {
    [1] = require("src.scripts.states.minigames.qte")
}

function minigame.load(index)

    if minigames[index].load then
        minigames[index].load()
    end

end

function minigame.update(dt, index)

    if minigames[index].update then
        minigames[index].update(dt)
    end

end

function minigame.draw(index)

    if minigames[index].draw then
        minigames[index].draw()
    end
end

return minigame