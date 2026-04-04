local menu = require("src.scripts.states.menu")

local current_state = nil
MAX_GAMES = 3
Games_created = {--[[ "Partida1", "Partida 2", "Partida 3" ]]}

-- esta funcion es global por lo tanto la puedes llamar desde cualquier parte
-- esta funcion sirve para cambiar de interfaz solo le pasas la nueva interfaz y esta se encarga
-- ejecutar el codigo de las mismas
function Change_state(new_state)
    current_state = new_state

    if current_state and current_state.load then
        current_state.load()
    end
end

function love.load()
    Change_state(menu)
end

function love.resize(w, h)
    if current_state and current_state.resize then
        current_state.resize(w, h)
    end

end

function love.update(dt)

    Cursor_position_x, Cursor_position_y = love.mouse.getPosition()

    if current_state and current_state.update then
        current_state.update(dt)
    end
end

function love.draw()
    if current_state and current_state.draw then
        current_state.draw()
    end
end

function love.mousereleased(x, y, button)
    if current_state and current_state.mousereleased then
        current_state.mousereleased(x, y, button)
    end
end

function love.textinput(t)
    if current_state and current_state.textinput then
        current_state.textinput(t)
    end
end

function love.keypressed(key)
    if current_state and current_state.keypressed then
        current_state.keypressed(key)
    end
end