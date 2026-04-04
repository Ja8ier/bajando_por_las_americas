local Panel = {}

function Panel.new(x, y, w, h, title, scale_title)
    
    return {

        x = x,
        y = y,
        w = w,
        h = h,
        title = title,
        scale_title = scale_title,
        visible = false,

        elements = {}
    }
end

function Panel.draw(new_panel)
    
    if not new_panel.visible then return end

    love.graphics.setColor(0.95, 0.95, 0.9)
    love.graphics.rectangle("fill", new_panel.x, new_panel.y, new_panel.w, new_panel.h, 10)

    love.graphics.setColor(0.1, 0.1, 0.1, 0.9)
    love.graphics.rectangle("line", new_panel.x, new_panel.y, new_panel.w, new_panel.h, 10)

    love.graphics.setColor(0,0,0)
    love.graphics.setFont(love.graphics.newFont(new_panel.scale_title))
    love.graphics.printf(new_panel.title, new_panel.x, new_panel.y + 20, new_panel.w, "center")

end

return Panel