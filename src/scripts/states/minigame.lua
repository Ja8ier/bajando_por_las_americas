local minigame = {}

local gamePlayingIndex

local minigames = {
    [1] = require("src.scripts.states.minigames.qte"),
    [2] = require("src.scripts.states.minigames.bomb defusal.bomb")
}

function minigame.load(index)

    if minigames[index].load then
        gamePlayingIndex = index
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

function minigame.keypressed(key)
    if minigames[gamePlayingIndex].keypressed then
        minigames[gamePlayingIndex].keypressed(key)
    end
end

function minigame.isExited(index)
    if minigames[index].draw then
        return minigames[index].isExited()
    end
end

function minigame.mousepressed(x, y, button)
    if minigames[gamePlayingIndex].mousepressed then
        minigames[gamePlayingIndex].mousepressed(x, y, button)
    end
end

return minigame