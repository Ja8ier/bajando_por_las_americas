-- en este archivo van los metodos que modifican la funcionalidad de un objeto (boton, texto, personaje...)  

local Utils = {}
local utf8 = require("utf8")

Utils.center_title_x = 0
Utils.font_title = nil
Utils.font_btn = nil
Utils.center_btn_x = 0
Utils.button_width = 0
Utils.button_height = 0
Utils.border_radius = 0
Utils.text_title = "Bajando por las Americas"
Utils.text_input = ""
Utils.writing = true

function Utils.Resize_scale(opcion, factor)
    if opcion == 1 then
        return (factor*love.graphics.getWidth())/1280

    elseif opcion == 2 then
        return (factor*love.graphics.getHeight())/720

    else
        return -1
    end

end

function Utils.Resize_dimentions_btn(w, h, br)
    Utils.button_width = (love.graphics.getWidth()*w)/1280
    Utils.button_height = (love.graphics.getHeight()*h)/720
    Utils.center_btn_x = (love.graphics.getWidth() - Utils.button_width)/2
    Utils.border_radius = (br*love.graphics.getWidth())/1280
end

function Utils.Resize_dimentions_title(text)
    Utils.center_title_x = (love.graphics.getWidth() - Utils.font_title:getWidth(text))/2

end

function Utils.Font_update(font_size_btn, font_size_title)

    local fs_btn = font_size_btn or 24
    local fs_title = font_size_title or 50
    local new_size_btn = Utils.Resize_scale(1, fs_btn)
    local new_size_title = Utils.Resize_scale(1, fs_title)

    if new_size_btn < 1 then new_size_btn = 1 end
    if new_size_title < 1 then new_size_title = 1 end
    
    Utils.font_btn = love.graphics.newFont(new_size_btn)
    Utils.font_title = love.graphics.newFont("assets/fonts/m04.TTF", new_size_title)
    Utils.font_btn:setFilter("nearest", "nearest")
    Utils.font_title:setFilter("nearest", "nearest")
end

function Utils.Search_opacity(left_x, right_x, up_y, down_y, active)

    if active then

        if Cursor_position_x > left_x and Cursor_position_x < right_x and
            Cursor_position_y > up_y and Cursor_position_y < down_y then
            return 1
        end
        return 0.5
    end

    return 0.5
end

function Utils.Tint(r, g, b, percent)
    local nr = r + (1 - r) * percent
    local ng = g + (1 - g) * percent
    local nb = b + (1 - b) * percent
    return nr, ng, nb
end

function Utils.IsHovering(x, y)

    if x > Utils.center_btn_x and x < Utils.center_btn_x + Utils.button_width then

        if y > Utils.Resize_scale(2, 400)  and
            y < Utils.Resize_scale(2, 400) + Utils.button_height then
            return 1

        elseif y > Utils.Resize_scale(2, 470) and
            y < Utils.Resize_scale(2, 470) + Utils.button_height then
            return 2

        elseif y > Utils.Resize_scale(2, 540) and
            y < Utils.Resize_scale(2, 540) + Utils.button_height then
            return 3
        
        elseif y > Utils.Resize_scale(2, 610) and
            y < Utils.Resize_scale(2, 610) + Utils.button_height then
            return 4
        end
    end

    return 0
end

function Utils.cursor()
    
end

function Utils.textinput(t)
    local font = love.graphics.getFont()

    if font:getWidth(Utils.text_input) < Space_max_for_write - font:getWidth(t) and Tbx_active[1] then
        Utils.text_input = Utils.text_input .. t

    end
end

function Utils.keypressed(key)
    if key == "backspace" then

        Utils.writing = not Utils.writing

        local byteoffset = utf8.offset(Utils.text_input, -1)
        if byteoffset then
            Utils.text_input = string.sub(Utils.text_input, 1, byteoffset - 1)
        end
    end
end

return Utils