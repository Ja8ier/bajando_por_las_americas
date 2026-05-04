local continue_game = {}

local gui = require("src.scripts.gui.gui")
local settings = require("src.scripts.states.settings")
local exit = require("src.scripts.states.exit")
local inputs = require("src.scripts.utils.inputs")

local sprite_Background
local active_edit = {}
local change_edit_name, change_delete_name = {}, {}
local active_btn = true
local btn_pressed = 0
local valid_text = true

function continue_game.load()
    
    love.keyboard.setKeyRepeat(true)

    gui.utils.Font_update()
    
    sprite_Background = love.graphics.newImage("assets/sprites/Menu_Background.png")

    for i = 1, #Games_created, 1 do
        table.insert(active_edit, false)
        table.insert(change_edit_name, "Editar")
        table.insert(change_delete_name, "Eliminar")
    end
end

function continue_game.resize(w, h)
    settings.resize(w, h)
    exit.resize(w, h)
    gui.utils.Font_update()
end

function continue_game.update(dt)
    gui.update(dt)
end

function continue_game.draw()

    love.graphics.setBackgroundColor(1, 1, 1)

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(sprite_Background, 0, 0, 0, love.graphics.getWidth()/256, love.graphics.getHeight()/144)

    love.graphics.setFont(gui.utils.font_title)
    gui.Draw_title("Partidas Guardadas", 30, {0.95, 0.95, 0.9})

    love.graphics.setFont(gui.utils.font_btn)

    gui.utils.Resize_dimentions_btn(600, 70, 10)

    if #Games_created == 0 then
        
        gui.Draw_button("NO hay partidas guardadas", gui.utils.center_btn_x, gui.utils.Resize_scale(2, 350),
                        gui.utils.button_width, gui.utils.button_height, gui.utils.border_radius, 0.7)
    else
        local x = gui.utils.center_btn_x + gui.utils.button_width + gui.utils.Resize_scale(1, 10)
        local y1 = 250
        local opacity_btn1, opacity_btn2, opacity_btn3 

        for i = 1, #Games_created, 1 do

            if i == btn_pressed then
                opacity_btn1 = 1
                opacity_btn2 = 0.5
                opacity_btn3 = 0.5
            else
                opacity_btn1 = gui.utils.Search_opacity(gui.utils.center_btn_x, gui.utils.center_btn_x + gui.utils.button_width,
                                gui.utils.Resize_scale(2, y1), gui.utils.Resize_scale(2, y1) + gui.utils.button_height, active_btn)
            end

            valid_text = gui.Draw_textbox(Games_created[i], gui.utils.center_btn_x, gui.utils.Resize_scale(2, y1), gui.utils.button_width, 
            gui.utils.button_height, gui.utils.border_radius, {active_edit[i], i}, {0.36, 0.25, 0.14}, {0.95, 0.95, 0.9}, opacity_btn1)

            gui.utils.Resize_dimentions_btn(100, 30, 5)
            love.graphics.setFont(love.graphics.newFont(gui.utils.Resize_scale(1, 20)))

            local y2 = gui.utils.Resize_scale(2, y1) + gui.utils.button_height + gui.utils.Resize_scale(2, 5)

            if i == btn_pressed or active_btn then
                opacity_btn2 = gui.utils.Search_opacity(x, x + gui.utils.button_width, gui.utils.Resize_scale(2, y1), 
                                gui.utils.Resize_scale(2, y1) + gui.utils.button_height, true)
                opacity_btn3 = gui.utils.Search_opacity(x, x + gui.utils.button_width, y2, y2 + gui.utils.button_height, true)
            else
                opacity_btn2 = 0.5
                opacity_btn3 = 0.5
            end

            gui.Draw_button(change_edit_name[i], x, gui.utils.Resize_scale(2, y1), gui.utils.button_width, gui.utils.button_height, gui.utils.border_radius,
            opacity_btn2, {0.2, 0.6, 0.86}, {1,1,1,1})

            gui.Draw_button(change_delete_name[i], x, y2, gui.utils.button_width, gui.utils.button_height, gui.utils.border_radius,
            opacity_btn3, {0.9, 0.3, 0.23}, {1,1,1,1})

            y1 = y1 + 100
            gui.utils.Resize_dimentions_btn(600, 70, 10)
            love.graphics.setFont(gui.utils.font_btn)
        end
    end

    gui.utils.Resize_dimentions_btn(200, 50, 15)

    gui.Draw_button(
    "Regresar", gui.utils.center_btn_x, gui.utils.Resize_scale(2, 610), gui.utils.button_width, gui.utils.button_height, gui.utils.border_radius, 
    gui.utils.Search_opacity(gui.utils.center_btn_x, gui.utils.center_btn_x + gui.utils.button_width, gui.utils.Resize_scale(2, 610),
                            gui.utils.Resize_scale(2, 610) + gui.utils.button_height, active_btn))
end

function continue_game.mousereleased(x, y, button)

    local bx1, bw1, bh1 = gui.utils.center_btn_x, gui.utils.button_width, gui.utils.button_height

    if x > bx1 and x < bx1 + bw1 and y > gui.utils.Resize_scale(2, 610) and y < gui.utils.Resize_scale(2, 610) + bh1 and active_btn then

        gui.utils.text_input = ""
        gui.utils.Resize_dimentions_btn(200, 50, 15) --por si acaso
        Change_state(require("src.scripts.states.menu"))
    
    else
        gui.utils.Resize_dimentions_btn(600, 70, 10)
        bx1, bw1, bh1 = gui.utils.center_btn_x, gui.utils.button_width, gui.utils.button_height
        
        gui.utils.Resize_dimentions_btn(100, 30, 5)
        local bw2, bh2 = gui.utils.button_width, gui.utils.button_height
        local bx2 = bx1 + bw1 + gui.utils.Resize_scale(1, 10)
        local by1 = 250

        for i = 1, #Games_created, 1 do
            
            if x > bx1 and x < bx1 + bw1 and y > gui.utils.Resize_scale(2, by1) and y < gui.utils.Resize_scale(2, by1) + bh1 and active_btn then
                
                gui.utils.text_input = ""
                
                --cambiar src.scripts.states.menu por src.scripts.states.stage1 para ejecutar el juego
                Change_state(require("src.scripts.states.stage1"))
                    
            elseif x > bx2 and x < bx2 + bw2 then
                local by2 = gui.utils.Resize_scale(2, by1) + bh2 + gui.utils.Resize_scale(2, 5)

                if y > gui.utils.Resize_scale(2, by1) and y < gui.utils.Resize_scale(2, by1) + bh2 then

                    if change_edit_name[i] == "Editar" and btn_pressed == 0 then

                        change_edit_name[i] = "Aplicar"
                        change_delete_name[i] = "Cancelar"

                        for j = 1, #Games_created, 1 do
                            if change_edit_name[j] == "Aplicar" then
                                gui.utils.text_input = Games_created[i]
                                active_edit[i] = true
                                active_btn = false
                                break
                            end
                        end

                        btn_pressed = i
                   
                    elseif change_edit_name[i] == "Aplicar" and valid_text then
                        
                        Games_created[i] = gui.utils.text_input
                        change_edit_name[i] = "Editar"
                        change_delete_name[i] = "Eliminar"
                        active_edit[i] = false
                        active_btn = true
                        btn_pressed = 0
                    end

                elseif y > by2 and y < by2 + bh2 then
                    if change_delete_name[i] == "Eliminar" then
                        local allow_delete = true

                        for j = 1, #Games_created, 1 do
                            if change_delete_name[j] == "Cancelar" then
                                allow_delete = false
                                break
                            end
                        end

                        if allow_delete then
                            table.remove(Games_created, i)
                            table.remove(active_edit, i)
                            table.remove(change_edit_name, i)
                            table.remove(change_delete_name, i)
                        end

                    elseif change_delete_name[i] == "Cancelar" then
                        gui.utils.text_input = ""
                        change_edit_name[i] = "Editar"
                        change_delete_name[i] = "Eliminar"
                        active_edit[i] = false
                        active_btn = true
                        btn_pressed = 0
                    end

                end
            end
            
            by1 = by1 +100
        end
    end
end

function continue_game.textinput(t)
    gui.utils.textinput(t)
end

-- function continue_game.keypressed(key)
--     gui.utils.keypressed(key)
-- end

function continue_game.keypressed(key)

    if Current_state == require("src.scripts.states.continue_the_game") then
        if key == inputs.createNewGame.back then
            Change_state(require("src.scripts.states.menu"))
        end
    end
    
end

return continue_game