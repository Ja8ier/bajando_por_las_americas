local exit = {}

local gui = require("src.scripts.gui.gui")
local panel = require("src.scripts.gui.panel")

local exit_panel = panel.new((love.graphics.getWidth() - gui.utils.Resize_scale(1, 400))/2, 
                                (love.graphics.getHeight() - gui.utils.Resize_scale(2, 200))/2, 
                                gui.utils.Resize_scale(1, 400), gui.utils.Resize_scale(2, 200), "¿Seguro desea salir?", gui.utils.Resize_scale(1, 30))

function exit.load()
    gui.utils.Resize_dimentions_btn(100, 32, 10)
end

function exit.resize(w, h)

    exit_panel.x = (love.graphics.getWidth() - gui.utils.Resize_scale(1, 400))/2
    exit_panel.y = (love.graphics.getHeight() - gui.utils.Resize_scale(2, 200))/2
    exit_panel.w = gui.utils.Resize_scale(1, 400)
    exit_panel.h = gui.utils.Resize_scale(2, 200)
    exit_panel.scale_title = gui.utils.Resize_scale(1, 30)
end

function exit.update(dt)
end

local function get_button_pos(relative_x, relative_y)
    local bx = exit_panel.x + gui.utils.Resize_scale(1, relative_x)
    local by = exit_panel.y + gui.utils.Resize_scale(2, relative_y)
    return bx, by
end

function exit.draw()

    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setColor(1, 1, 1, 1)

    exit_panel.visible = true
    panel.draw(exit_panel)

    local bx, by = get_button_pos(65, 120)
    local bw, bh = gui.utils.button_width, gui.utils.button_height

    love.graphics.setFont(love.graphics.newFont(gui.utils.Resize_scale(1, 20)))

    gui.Draw_button("SI", bx, by, bw, bh, gui.utils.border_radius, gui.utils.Search_opacity(bx, bx + bw, by, by + bh, true))

    local bx, by = get_button_pos(235, 120)
                    
    gui.Draw_button("NO", bx, by, bw, bh, gui.utils.border_radius, gui.utils.Search_opacity(bx, bx + bw, by, by + bh, true))

    gui.utils.Resize_dimentions_btn(200, 50, 15)

end

function exit.mousereleased(x, y, button)

    gui.utils.Resize_dimentions_btn(100, 32, 10)

    local bx1, by1 = get_button_pos(65, 120)
    local bx2, by2 = get_button_pos(235, 120)
    local bw, bh = gui.utils.button_width, gui.utils.button_height

    gui.utils.Resize_dimentions_btn(200, 50, 15)

    if y > by1 and y < by1 + bh then
        
        if x > bx1 and x < bx1 + bw then
            
            exit_panel.visible = false
            return 1
        
        elseif x > bx2 and x < bx2 + bw then
            
            exit_panel.visible = false
            return 2
        end
    end

    return 0
end

return exit