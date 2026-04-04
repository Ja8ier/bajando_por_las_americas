-- en este archivo se crea lo visual sin ninguna funcionalidad (botones, titulos, personasjes). Solo lo visual

local GUI = {}

GUI.utils = require("src.scripts.utils.gui_utils")

local cursor_visible = true
local timer_accumulator = 0
local execution_interval = 0.5
local btn

function GUI.update(dt)
    timer_accumulator = timer_accumulator + dt

    if timer_accumulator >= execution_interval then

        cursor_visible = not cursor_visible

        timer_accumulator = 0
    end
end

function GUI.Draw_title(content, position_y, color)

    GUI.utils.Resize_dimentions_title(content)

    local center_title_y = GUI.utils.Resize_scale(2, position_y)
    local c = color or {0,0,0}

    love.graphics.setColor(c[1], c[2], c[3])
    love.graphics.setLineWidth(10)
    love.graphics.print(content, GUI.utils.center_title_x, center_title_y)

    love.graphics.setColor(1,1,1)

end

function GUI.Draw_button(text, position_x, position_y, width, height, border_r, opacity, btn_color, font_color)
    
    local font = love.graphics.getFont()
    local text_center_x = position_x + (width - font:getWidth(text))/2
    local text_center_y = position_y + (height - font:getHeight())/2
    local c = btn_color or {1, 1, 1}
    local f = font_color or {0,0,0,1}

    love.graphics.setColor(0, 0, 0)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", position_x, position_y, width, height, border_r, border_r)

    love.graphics.setColor(c[1], c[2], c[3], opacity)
    love.graphics.rectangle("fill", position_x, position_y, width, height, border_r, border_r)

    love.graphics.setColor(f[1], f[2], f[3], f[4])
    love.graphics.print(text, text_center_x, text_center_y)

    -- Opcional: Resetear aquí también para evitar sorpresas en otras funciones
    love.graphics.setColor(1, 1, 1)
end

function GUI.Draw_textbox(text, position_x, position_y, width, height, border_r, active, tbx_color, font_color, opacity)

    local font = love.graphics.getFont()
    local inter_width = width*0.95
    local inter_height = height*0.8
    local btn_center_x = position_x + (width - inter_width)/2
    local btn_center_y = position_y + (height - inter_height)/2
    local c1 = tbx_color or {1, 1, 1, 1}
    local c2 = {GUI.utils.Tint(c1[1], c1[2], c1[3], 0.2)}
    local f = font_color or {0,0,0,1}
    Space_max_for_write = inter_width - (width - inter_width)

    if active[1] then
        btn = active[2]
        Tbx_active = {true, btn}

    elseif not active[1] and active[2] == btn then
        Tbx_active = {false, btn}
    end

    love.graphics.setColor(0, 0, 0)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", position_x, position_y, width, height, border_r, border_r)

    love.graphics.setColor(c2[1], c2[2], c2[3], opacity or 0.9)
    love.graphics.rectangle("fill", position_x, position_y, width, height, border_r, border_r)

    love.graphics.setColor(0, 0, 0)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", btn_center_x, btn_center_y, inter_width, inter_height)

    if opacity ~= nil then opacity = opacity+0.3 end

    love.graphics.setColor(c1[1], c1[2], c1[3], opacity or c1[4])
    love.graphics.rectangle("fill", btn_center_x, btn_center_y, inter_width, inter_height)

    if cursor_visible and active[1] then
        love.graphics.setColor(f[1], f[2], f[3], 1)
        love.graphics.print("|", btn_center_x + (width - inter_width)/2 + font:getWidth(GUI.utils.text_input), position_y + (height - font:getHeight())/2)
    end

    if GUI.utils.text_input == "" then

        if not active[1] then 
            love.graphics.setColor(f[1], f[2], f[3], f[4])
            love.graphics.print(text, btn_center_x + (width - inter_width)/2, position_y + (height - font:getHeight())/2)
        end

        love.graphics.setColor(1, 1, 1)
        return false, 0.5

    elseif active[2] == btn then
        love.graphics.setColor(f[1], f[2], f[3], 1)
        love.graphics.print(GUI.utils.text_input, btn_center_x + (width - inter_width)/2, position_y + (height - font:getHeight())/2)

        love.graphics.setColor(1, 1, 1)
        return true, 1
    else
        love.graphics.setColor(f[1], f[2], f[3], 1)
        love.graphics.print(text, btn_center_x + (width - inter_width)/2, position_y + (height - font:getHeight())/2)
        love.graphics.setColor(1, 1, 1)

        return true
    end
end

return GUI