local menu = {}


--variables globales
Cursor_position_x = 0; Cursor_position_y = 0

-- esto son como importaciones: es como llamar una intancias de otro archivo, pero tienes acceso a las variables
-- originales, no copias
local settings = require("src.scripts.states.settings")
local exit = require("src.scripts.states.exit")
local gui = require("src.scripts.gui.gui")
local inputs = require("src.scripts.utils.inputs")

--variables locales
local sprite_Background_menu
local active = true

menu.Show_settings = false
menu.Show_exit = false

function menu.load()

    love.graphics.setDefaultFilter("nearest", "nearest")

    gui.utils.font_title = love.graphics.newFont("assets/fonts/m04.TTF", 50)

    gui.utils.Font_update()
    gui.utils.Resize_dimentions_btn(200, 50, 15)

    sprite_Background_menu = love.graphics.newImage("assets/sprites/Menu_Background.png")

end

function menu.resize(w, h)

    gui.utils.Font_update()
    gui.utils.Resize_dimentions_btn(200, 50, 15)
    settings.resize(w, h)
    exit.resize(w, h)

end

function menu.update(dt)

    if menu.Show_settings then
        -- solo entra aqui si las configuraciones estan abiertas
    else
        -- solo entra aqui si las configuraciones estan cerradas
    end
end

function menu.draw()

    love.graphics.setBackgroundColor(1, 1, 1)

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(sprite_Background_menu, 0, 0, 0, love.graphics.getWidth()/256, love.graphics.getHeight()/144)

    love.graphics.setFont(gui.utils.font_title)
    gui.Draw_title(gui.utils.text_title, 30, {0.95, 0.95, 0.9})

    love.graphics.setFont(gui.utils.font_btn)

    gui.Draw_button(
        "Nueva Partida", gui.utils.center_btn_x, gui.utils.Resize_scale(2, 400), gui.utils.button_width, gui.utils.button_height, gui.utils.border_radius, 
        gui.utils.Search_opacity(gui.utils.center_btn_x, gui.utils.center_btn_x + gui.utils.button_width,
                                gui.utils.Resize_scale(2, 400), gui.utils.Resize_scale(2, 400) + gui.utils.button_height, active))

    gui.Draw_button(
        "Continuar", gui.utils.center_btn_x, gui.utils.Resize_scale(2, 470), gui.utils.button_width, gui.utils.button_height, gui.utils.border_radius, 
        gui.utils.Search_opacity(gui.utils.center_btn_x, gui.utils.center_btn_x + gui.utils.button_width, 
                                gui.utils.Resize_scale(2, 470), gui.utils.Resize_scale(2, 470) + gui.utils.button_height, active))

    gui.Draw_button(
        "Ajustes", gui.utils.center_btn_x, gui.utils.Resize_scale(2, 540), gui.utils.button_width, gui.utils.button_height, gui.utils.border_radius, 
        gui.utils.Search_opacity(gui.utils.center_btn_x, gui.utils.center_btn_x + gui.utils.button_width,
                                gui.utils.Resize_scale(2, 540), gui.utils.Resize_scale(2, 540) + gui.utils.button_height, active))

    gui.Draw_button(
        "Salir", gui.utils.center_btn_x, gui.utils.Resize_scale(2, 610), gui.utils.button_width, gui.utils.button_height, gui.utils.border_radius, 
        gui.utils.Search_opacity(gui.utils.center_btn_x, gui.utils.center_btn_x + gui.utils.button_width,
                                gui.utils.Resize_scale(2, 610), gui.utils.Resize_scale(2, 610) + gui.utils.button_height, active))
                                
    if menu.Show_settings then
        
        active = false

        settings.load()
        settings.draw()

    elseif menu.Show_exit then
        
        active = false

        exit.load()
        exit.draw()
    end
end

function menu.mousereleased(x, y, button)

    if menu.Show_settings then
        local stop_settings = settings.mousereleased(x, y, button)

        if stop_settings then
            menu.Show_settings = false
            active = true
        end

    elseif menu.Show_exit then
        local close_game = exit.mousereleased(x, y, button)

        if close_game == 1 then
            love.event.quit()
        
        elseif close_game == 2 then
            menu.Show_exit = false
            active = true
        end

    else
        local type_btn = gui.utils.IsHovering(x, y)

        if type_btn ~= 0 then
            
            if type_btn == 1 then
                Change_state(require("src.scripts.states.create_new_game"))
            
            elseif type_btn == 2 then
                Change_state(require("src.scripts.states.continue_the_game"))

            elseif type_btn == 3 then
                menu.Show_settings = true

            elseif type_btn == 4 then
                menu.Show_exit = true
            end
        end
    end
end

function menu.keypressed(key)

    if Current_state == require("src.scripts.states.menu") then

        if key == inputs.menu.newGame then
            Change_state(require("src.scripts.states.create_new_game"))
        elseif key == inputs.menu.continueGame then
            Change_state(require("src.scripts.states.continue_the_game"))
        elseif key == inputs.menu.settings then
            --Change_state(require("src.scripts.states."))
        elseif key == inputs.menu.exit then
            --Change_state(require("src.scripts.states.create_new_game"))
        end
        
    end
end

return menu