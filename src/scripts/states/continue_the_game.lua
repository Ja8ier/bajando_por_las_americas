local continue_game = {}

function continue_game.load()
end

function continue_game.resize(w, h)
end

function continue_game.update(dt)
end

function continue_game.draw()
    love.graphics.setColor(0,0,0)
    love.graphics.print("aqui se deberia mostrar un submenu con tres partidas guardas, o las que hayan.\n si no hay no se abre esta interfaz", 100, 300)
end

return continue_game