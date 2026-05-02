local menu = require("src.scripts.states.menu")

Current_state = nil
MAX_GAMES = 3
Games_created = {--[[ "Partida1", "Partida 2", "Partida 3" ]]}

-- esta funcion es global por lo tanto la puedes llamar desde cualquier parte
-- esta funcion sirve para cambiar de interfaz solo le pasas la nueva interfaz y esta se encarga
-- ejecutar el codigo de las mismas
function Change_state(new_state)
    Current_state = new_state

    if Current_state and Current_state.load then
        Current_state.load()
    end
end

function love.load()
    Change_state(menu)
end

function love.resize(w, h)
    if Current_state and Current_state.resize then
        Current_state.resize(w, h)
    end

end

function love.update(dt)

    Cursor_position_x, Cursor_position_y = love.mouse.getPosition()

    if Current_state and Current_state.update then
        Current_state.update(dt)
    end
end

function love.draw()
    if Current_state and Current_state.draw then
        Current_state.draw()
    end
end

function love.mousereleased(x, y, button)
    if Current_state and Current_state.mousereleased then
        Current_state.mousereleased(x, y, button)
    end
end

function love.textinput(t)
    if Current_state and Current_state.textinput then
        Current_state.textinput(t)
    end
end

function love.keypressed(key)
    if Current_state and Current_state.keypressed then
        Current_state.keypressed(key)
    end
end