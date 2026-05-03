local collisionBox = {
    x = 0,
    y = 0,
    width = 0,
    height = 0
}

collisionBox.TYPES = {
    BOTTOM = "bottom",
    TOP = "top",
    FULL = "full",
    -- CUSTOM = "custom" --solo para casos especiales donde se necesite una colision particular
}

local scale = love.graphics.getWidth() / 256

function collisionBox.create(entity, type)
    
    local _x
    local _y
    local _width
    local _height
    local _type

    --Ancho y alto

    _width = (entity.width) * scale

    if type == collisionBox.TYPES.BOTTOM or type == collisionBox.TYPES.TOP then
        _height = (entity.height * scale) / 3
    elseif type == collisionBox.TYPES.FULL then
        _height = entity.height * scale
    end

    --posicion X
    _x = entity.x
    
    --posicion Y
    if type == collisionBox.TYPES.FULL or type == collisionBox.TYPES.TOP then
        _y = entity.y
    elseif type == collisionBox.TYPES.BOTTOM then
        _y = entity.y + ((2 * entity.height * scale) / 3)
    end

    --tipo de collision box
    if type == collisionBox.TYPES.BOTTOM then
        _type = collisionBox.TYPES.BOTTOM
    elseif type == collisionBox.TYPES.TOP then
        _type = collisionBox.TYPES.TOP
    elseif type == collisionBox.TYPES.FULL then
    _type = collisionBox.TYPES.FULL
    end

    entity.collisionBox = {
        width = _width,
        height = _height,
        x = _x,
        y = _y,
        type = _type
    }

    entity.updateCollisionBox = function()
        collisionBox.updatePosition(entity)
    end

    return entity

end

function collisionBox.check(entity, object)

    return entity.collisionBox.x < object.collisionBox.x + object.collisionBox.width and
            object.collisionBox.x < entity.collisionBox.x + entity.collisionBox.width and 
            entity.collisionBox.y < object.collisionBox.y + object.collisionBox.height and
            object.collisionBox.y < entity.collisionBox.y + entity.collisionBox.height

end

function collisionBox.updatePosition(entity)
    
    --posicion X
    
    entity.collisionBox.x = entity.x
    
    --posicion Y
    if entity.collisionBox.type == collisionBox.TYPES.FULL or entity.collisionBox.type  == collisionBox.TYPES.TOP then
        entity.collisionBox.y = entity.y
    elseif entity.collisionBox.type == collisionBox.TYPES.BOTTOM then
        entity.collisionBox.y = entity.y + ((2 * entity.height * scale) / 3)
    end
    
end

function collisionBox.resolveX(entity, object)
    if collisionBox.check(entity, object) then
        --ver si el centro de la entity esta a la izquierda o derecha del objeto
        local entityCenterX = entity.collisionBox.x + (entity.collisionBox.width / 2)
        local objectCenterX = object.collisionBox.x + (object.collisionBox.width / 2)

        if entityCenterX < objectCenterX then
            --colision por la izquierda
            entity.x = object.collisionBox.x - entity.collisionBox.width
        else
            --colision por la derecha
            entity.x = object.collisionBox.x + object.collisionBox.width
        end
        --actualizar la collisionBox
        entity.updateCollisionBox()
    end
end

function collisionBox.resolveY(entity, object)
    if collisionBox.check(entity, object) then
        local entityCenterY = entity.collisionBox.y + (entity.collisionBox.height / 2)
        local objectCenterY = object.collisionBox.y + (object.collisionBox.height / 2)

        --el offset es la distancia desde la Y del sprite hasta donde empiezan los pies
        local offsetY = entity.collisionBox.y - entity.y 

        if entityCenterY < objectCenterY then
            --colision por arriba
            entity.y = object.collisionBox.y - entity.collisionBox.height - offsetY
        else
            --colision por abajo
            entity.y = object.collisionBox.y + object.collisionBox.height - offsetY
        end
        entity.updateCollisionBox()
    end
end

function collisionBox.isAhead(entity, object)
    local ABottom = entity.collisionBox.y + entity.collisionBox.height
    local bBottom = object.collisionBox.y + object.collisionBox.height

    return ABottom < bBottom
end

function collisionBox.showBoxes(player, obstacles, show)

    if show then
        --caja del player
        love.graphics.setColor(1, 1, 1, 0.25)
        love.graphics.rectangle("fill", player.collisionBox.x, player.collisionBox.y, player.collisionBox.width, player.collisionBox.height)

        --cajas de colision
        love.graphics.setColor(1, 0.1, 0.1, 0.25)
        for _, obs in ipairs(obstacles) do
            love.graphics.rectangle("fill", obs.collisionBox.x, obs.collisionBox.y, obs.collisionBox.width, obs.collisionBox.height)
        end
        love.graphics.setColor(1, 1, 1)
    else
        return
    end
    
end
return collisionBox