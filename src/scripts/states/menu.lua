local menu = {}

--variables globales
Cursor_position_x = 0; Cursor_position_y = 0

-- esto son como importaciones: es como llamar una intancias de otro archivo, pero tienes acceso a las variables
-- originales, no copias
local settings = require("src.scripts.states.settings")
local utils = require("src.scripts.utils.gui_utils")
local gui = require("src.scripts.gui.gui")

--variables locales
local sprite_Background_menu

menu.Show_settings = false

function menu.load()

    love.graphics.setDefaultFilter("nearest", "nearest")

    utils.font_title = love.graphics.newFont("assets/fonts/m04.TTF", 50)

    utils.Font_update()
    utils.Resize_dimentions_title()
    utils.Resize_dimentions_btn()

    sprite_Background_menu = love.graphics.newImage("assets/sprites/Menu_Background.png")

end

function menu.resize(w, h)

    utils.Font_update()
    utils.Resize_dimentions_btn()
    utils.Resize_dimentions_title()

end

function menu.update(dt)

    if menu.Show_settings then
        settings.update(dt)
    else
        -- solo entra aqui si las configuraciones estan cerradas
        Cursor_position_x, Cursor_position_y = love.mouse.getPosition()
    end
end

function menu.draw()

    love.graphics.setBackgroundColor(1, 1, 1)

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(sprite_Background_menu, 0, 0, 0, love.graphics.getWidth()/256, love.graphics.getHeight()/144)

    love.graphics.setFont(utils.font_title)
    gui.Draw_title()

    love.graphics.setFont(utils.font_btn)

    gui.Draw_button(
        "Nueva Partida", utils.center_btn_x, utils.Resize_scale(2, 400), utils.button_width, utils.button_height, utils.border_radius, 
        utils.Search_opacity(utils.Resize_scale(2, 400), utils.Resize_scale(2, 400) + utils.button_height))

    gui.Draw_button(
        "Continuar", utils.center_btn_x, utils.Resize_scale(2, 470), utils.button_width, utils.button_height, utils.border_radius, 
        utils.Search_opacity(utils.Resize_scale(2, 470), utils.Resize_scale(2, 470) + utils.button_height))

    gui.Draw_button(
        "Ajustes", utils.center_btn_x, utils.Resize_scale(2, 540), utils.button_width, utils.button_height, utils.border_radius, 
        utils.Search_opacity(utils.Resize_scale(2, 540), utils.Resize_scale(2, 540) + utils.button_height))

    gui.Draw_button(
        "Salir", utils.center_btn_x, utils.Resize_scale(2, 610), utils.button_width, utils.button_height, utils.border_radius, 
        utils.Search_opacity(utils.Resize_scale(2, 610), utils.Resize_scale(2, 610) + utils.button_height))


    if menu.Show_settings then
        
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("fill", (love.graphics.getWidth() - utils.Resize_scale(1, 400))/2, 
        (love.graphics.getHeight() - utils.Resize_scale(2, 500))/2, utils.Resize_scale(1, 400), utils.Resize_scale(2, 500))
    
        love.graphics.setColor(1, 1, 1, 1)

        settings.draw()
    end
end

function menu.mousereleased(x, y, button)

    if menu.Show_settings then
        settings.mousereleased(x, y, button)

    else
        local type_btn = utils.IsHovering(x, y)

        if type_btn ~= 0 then
            
            if type_btn == 1 then
                Change_state(require("src.scripts.states.create_new_game"))
            
            elseif type_btn == 2 then
                Change_state(require("src.scripts.states.continue_the_game"))

            elseif type_btn == 3 then
                --abrir ventana de configuraciones pero no puede quitar la ventana de menu
                menu.Show_settings = true

            elseif type_btn == 4 then
                -- falta mostrar un mensaje de confirmacion para cerrar
                love.event.quit()
            end
        end
    end
end

return menu