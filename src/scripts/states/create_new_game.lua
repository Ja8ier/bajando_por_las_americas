local new_game = {}

local gui = require("src.scripts.gui.gui")
local settings = require("src.scripts.states.settings")
local exit = require("src.scripts.states.exit")

local sprite_Background
local active_btn = false
local textbox_active = false

function new_game.load()

    love.keyboard.setKeyRepeat(true)

    gui.utils.Font_update()

    sprite_Background = love.graphics.newImage("assets/sprites/Menu_Background.png")

end

function new_game.resize(w, h)
    settings.resize(w, h)
    exit.resize(w, h)
    gui.utils.Font_update()
end

function new_game.update(dt)
    gui.update(dt)
end

function new_game.draw()
    local opacity_btn

    love.graphics.setBackgroundColor(1, 1, 1)

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(sprite_Background, 0, 0, 0, love.graphics.getWidth()/256, love.graphics.getHeight()/144)

    love.graphics.setFont(gui.utils.font_title)
    gui.Draw_title("Crear Nueva Partida", 30, {0.95, 0.95, 0.9})
    
    love.graphics.setFont(gui.utils.font_btn)

    gui.utils.Resize_dimentions_btn(600, 70, 10)
    active_btn, opacity_btn = gui.Draw_textbox("Ingrese el nombre de la nueva partida", gui.utils.center_btn_x, gui.utils.Resize_scale(2, 300),
    gui.utils.button_width, gui.utils.button_height, gui.utils.border_radius, {textbox_active, 1}, {0.36, 0.25, 0.14}, {0.95, 0.95, 0.9, 0.5})

    gui.Draw_button(
    "Crear", gui.utils.center_btn_x, gui.utils.Resize_scale(2, 380), gui.utils.button_width, gui.utils.button_height, gui.utils.border_radius, 
    opacity_btn, {0.11, 0.49, 0.09}, {1,1,1})

    gui.utils.Resize_dimentions_btn(200, 50, 15)
    gui.Draw_button(
    "Regresar", gui.utils.center_btn_x, gui.utils.Resize_scale(2, 610), gui.utils.button_width, gui.utils.button_height, gui.utils.border_radius, 
    gui.utils.Search_opacity(gui.utils.center_btn_x, gui.utils.center_btn_x + gui.utils.button_width,
                            gui.utils.Resize_scale(2, 610), gui.utils.Resize_scale(2, 610) + gui.utils.button_height, true))
end

function new_game.mousereleased(x, y, button)

    local bx, bw, bh = gui.utils.center_btn_x, gui.utils.button_width, gui.utils.button_height

    gui.utils.Resize_dimentions_btn(600, 70, 10)

    if x > bx and x < bx + bw and
    y > gui.utils.Resize_scale(2, 610) and y < gui.utils.Resize_scale(2, 610) + bh then

        textbox_active = false
        gui.utils.text_input = ""
        Change_state(require("src.scripts.states.menu"))
    
    elseif x > gui.utils.center_btn_x and x < gui.utils.center_btn_x + gui.utils.button_width then

        if y > gui.utils.Resize_scale(2, 380) and y < gui.utils.Resize_scale(2, 380) + gui.utils.button_height and active_btn then
            
            if #Games_created < MAX_GAMES then

                table.insert(Games_created, gui.utils.text_input)
                gui.utils.text_input = ""

                textbox_active = false
                
           --     Change_state(require("src.scripts.states.stage1")) --descomentar esta linea para ejecutar el juego al crear la partida

            else
                textbox_active = false
            end


        elseif y > gui.utils.Resize_scale(2, 300) and y < gui.utils.Resize_scale(2, 300) + gui.utils.button_height then
            textbox_active = true

        else 
            textbox_active = false
        end  
    else
        textbox_active = false
    end
end

function new_game.textinput(t)
    gui.utils.textinput(t)
end

function new_game.keypressed(key)
    gui.utils.keypressed(key)
end

function love.keypressed(key)
    if key == "return" then
        Change_state(require("src.scripts.states.stage1"))
    end
end

return new_game