local settings = {}

local gui = require("src.scripts.gui.gui")
local panel = require("src.scripts.gui.panel")
local sounds = require("src.scripts.sounds.sounds")

local setting_panel = panel.new((love.graphics.getWidth() - gui.utils.Resize_scale(1, 400))/2, 
                                (love.graphics.getHeight() - gui.utils.Resize_scale(2, 500))/2, 
                                gui.utils.Resize_scale(1, 400), gui.utils.Resize_scale(2, 500), "AJUSTES", gui.utils.Resize_scale(1, 30))

Audio = true

local spriteControls = love.graphics.newImage("assets/sprites/controls.png")
function settings.load()
    gui.utils.Resize_dimentions_btn(100, 32, 10)
end

function settings.resize(w, h)

    setting_panel.x = (love.graphics.getWidth() - gui.utils.Resize_scale(1, 400))/2
    setting_panel.y = (love.graphics.getHeight() - gui.utils.Resize_scale(2, 500))/2
    setting_panel.w = gui.utils.Resize_scale(1, 400)
    setting_panel.h = gui.utils.Resize_scale(2, 500)
    setting_panel.scale_title = gui.utils.Resize_scale(1, 30)
end

function settings.update(dt)
end

local function get_button_pos(relative_x, relative_y)
    local bx = setting_panel.x + gui.utils.Resize_scale(1, relative_x)
    local by = setting_panel.y + gui.utils.Resize_scale(2, relative_y)
    return bx, by
end

function settings.draw()

    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setColor(1, 1, 1, 1)

    setting_panel.visible = true
    panel.draw(setting_panel)

    local bx, by = get_button_pos(210, 530)
    local bw, bh = gui.utils.button_width, gui.utils.button_height

    love.graphics.setFont(love.graphics.newFont(gui.utils.Resize_scale(1, 20)))
    gui.Draw_button("Listo", bx, by, bw, bh, gui.utils.border_radius, gui.utils.Search_opacity(bx, bx + bw, by, by + bh, true))

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print("Audio Off / On", setting_panel.x + 140, setting_panel.y + 120)
    love.graphics.setColor(0.5, 0.5, 0.5, 0.3)
    love.graphics.rectangle("fill", setting_panel.x + 305, setting_panel.y + 117, 60, 30, 15)

    if Audio then
        love.graphics.setColor(0.3, 0.5, 0.85, 1)
        love.graphics.rectangle("fill", setting_panel.x + 335, setting_panel.y + 117, 30, 30, 15)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("line", setting_panel.x + 305, setting_panel.y + 117, 60, 30, 15)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("line", setting_panel.x + 335, setting_panel.y + 117, 30, 30, 15)
    else
        love.graphics.setColor(0.5, 0.5, 0.5, 0.6)
        love.graphics.rectangle("fill", setting_panel.x + 305, setting_panel.y + 117, 30, 30, 15)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("line", setting_panel.x + 305, setting_panel.y + 117, 60, 30, 15)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("line", setting_panel.x + 305, setting_panel.y + 117, 30, 30, 15)
    end

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print("Controles", setting_panel.x + (setting_panel.w - 90)/2, setting_panel.y + 180)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(spriteControls, setting_panel.x + 5, setting_panel.y + 230, 0, 0.615, 0.615)

    gui.utils.Resize_dimentions_btn(200, 50, 15)
end

function settings.mousereleased(x, y, button)

    gui.utils.Resize_dimentions_btn(100, 32, 10)
    local bx, by = get_button_pos(210, 530)
    local bw, bh = gui.utils.button_width, gui.utils.button_height
    gui.utils.Resize_dimentions_btn(200, 50, 15)

    if x > bx and x < bx + bw and y > by and y < by + bh then
        setting_panel.visible = false
        return true
    end

    -- DETECTOR DEL CLIC EN EL SWITCH DE AUDIO
    if x > setting_panel.x + 305 and x < setting_panel.x + 365 and y > setting_panel.y + 117 and y < setting_panel.y + 147 then
        Audio = not Audio
        sounds.update() -- ESTA LÍNEA PARA APLICAR EL CAMBIO EN TIEMPO REAL
    end
    
    return false
end
return settings