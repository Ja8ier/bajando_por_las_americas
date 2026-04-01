-- en este archivo van los metodos que modifican la funcionalidad de un objeto (boton, texto, personaje...)  

local Utils = {}

Utils.center_title_x = 0
Utils.font_title = nil
Utils.font_btn = nil
Utils.center_btn_x = 0
Utils.button_width = 0
Utils.button_height = 0
Utils.border_radius = 0
Utils.text_title = "Bajando por las Americas"

function Utils.Resize_scale(opcion, factor)
    if opcion == 1 then
        return (factor*love.graphics.getWidth())/1280

    elseif opcion == 2 then
        return (factor*love.graphics.getHeight())/720

    else
        return -1
    end

end

function Utils.Resize_dimentions_btn()
    Utils.button_width = (love.graphics.getWidth()*200)/1280
    Utils.button_height = (love.graphics.getHeight()*50)/720
    Utils.center_btn_x = (love.graphics.getWidth() - Utils.button_width)/2
    Utils.border_radius = (15*love.graphics.getWidth())/1280

end

function Utils.Resize_dimentions_title()
    Utils.center_title_x = (love.graphics.getWidth() - Utils.font_title:getWidth(Utils.text_title))/2

end

function Utils.Font_update()

    local scale = love.graphics.getWidth() / 1280
    local new_size_btn = math.floor(24 * scale)
    local new_size_title = math.floor(50 * scale)

    if new_size_btn < 1 then new_size_btn = 1 end
    if new_size_title < 1 then new_size_title = 1 end
    
    Utils.font_btn = love.graphics.newFont(new_size_btn)
    Utils.font_title = love.graphics.newFont("assets/fonts/m04.TTF", new_size_title)
    Utils.font_btn:setFilter("nearest", "nearest")
    Utils.font_title:setFilter("nearest", "nearest")
end

function Utils.Search_opacity(up_y, down_y)

    if Cursor_position_x > Utils.center_btn_x and Cursor_position_x < Utils.center_btn_x + Utils.button_width and 
        Cursor_position_y > up_y and Cursor_position_y < down_y then
        return 1
    end

    return 0.5
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

return Utils