local settings = {}

local utils = require("src.scripts.utils.gui_utils")

function settings.load()
end

function settings.resize(w, h)
end

function settings.update(dt)
end

function settings.draw()

    love.graphics.setColor(0,0,0)
    love.graphics.print("aqui van las \nconfiguraciones del juego\n no tocar por ahora.\nTengo pensado construir\n esta ventana de otra forma", 450, 300)
end

function settings.mousereleased(x, y, button)
end
return settings