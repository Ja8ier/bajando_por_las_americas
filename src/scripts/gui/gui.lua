-- en este archivo se crea lo visual sin ninguna funcionalidad (botones, titulos, personasjes). Solo lo visual

--variables locales

local utils = require("src.scripts.utils.gui_utils")

local GUI = {}

function GUI.Draw_title()

    local center_title_y = utils.Resize_scale(2, 30)

    love.graphics.setColor(0.95, 0.95, 0.9)
    love.graphics.setLineWidth(10)
    love.graphics.print(utils.text_title, utils.center_title_x, center_title_y)

    love.graphics.setColor(1,1,1)

end

function GUI.Draw_button(text, position_x, position_y, width, height, border_r, opacity)
    
    local font = love.graphics.getFont()
    local text_center_x = position_x + (width - font:getWidth(text))/2
    local text_center_y = position_y + (height - font:getHeight())/2

    love.graphics.setColor(0, 0, 0)
    love.graphics.setLineWidth(5)
    love.graphics.rectangle("line", position_x, position_y, width, height, border_r, border_r)
    
    love.graphics.setColor(1, 1, 1, opacity)
    love.graphics.rectangle("fill", position_x, position_y, width, height, border_r, border_r)

    love.graphics.setColor(0,0,0)
    love.graphics.print(text, text_center_x, text_center_y)

    -- Opcional: Resetear aquí también para evitar sorpresas en otras funciones
    love.graphics.setColor(1, 1, 1)
end

return GUI