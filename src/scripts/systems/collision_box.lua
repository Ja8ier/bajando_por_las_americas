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

    --Posicion x
    _x = entity.x
    
    --Posicion y
    if type == collisionBox.TYPES.FULL or type == collisionBox.TYPES.TOP then
        _y = entity.y
    elseif type == collisionBox.TYPES.BOTTOM then
        _y = entity.y + ((2 * entity.height * scale) / 3)
    end

    --Definir tipo de collision box
    if type == collisionBox.TYPES.BOTTOM then
        _type = collisionBox.TYPES.BOTTOM
    elseif type == collisionBox.TYPES.TOP then
        _type = collisionBox.TYPES.TOP
    elseif type == collisionBox.TYPES.FULL then
    _type = collisionBox.TYPES.FULL
    end

    --Crear  la collisionBox
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
    
    --Posicion x
    
    entity.collisionBox.x = entity.x
    
    --Posicion y
    if entity.collisionBox.type == collisionBox.TYPES.FULL or entity.collisionBox.type  == collisionBox.TYPES.TOP then
        entity.collisionBox.y = entity.y
    elseif entity.collisionBox.type == collisionBox.TYPES.BOTTOM then
        entity.collisionBox.y = entity.y + ((2 * entity.height * scale) / 3)
    end
    
end

function collisionBox.resolveX(entity, object)
    if collisionBox.check(entity, object) then
        -- Determinamos si el centro de la entidad está a la izquierda o derecha del objeto
        local entityCenterX = entity.collisionBox.x + (entity.collisionBox.width / 2)
        local objectCenterX = object.collisionBox.x + (object.collisionBox.width / 2)

        if entityCenterX < objectCenterX then
            -- Colisión por la izquierda
            entity.x = object.collisionBox.x - entity.collisionBox.width
        else
            -- Colisión por la derecha
            entity.x = object.collisionBox.x + object.collisionBox.width
        end
        entity.updateCollisionBox() -- Actualizar la caja tras el reajuste
    end
end

function collisionBox.resolveY(entity, object)
    if collisionBox.check(entity, object) then
        local entityCenterY = entity.collisionBox.y + (entity.collisionBox.height / 2)
        local objectCenterY = object.collisionBox.y + (object.collisionBox.height / 2)

        -- El offset es la distancia desde la 'y' del sprite hasta donde empiezan los pies
        local offsetY = entity.collisionBox.y - entity.y 

        if entityCenterY < objectCenterY then
            -- Colisión por arriba (te paras sobre el objeto)
            entity.y = object.collisionBox.y - entity.collisionBox.height - offsetY
        else
            -- Colisión por abajo (chocas la cabeza)
            entity.y = object.collisionBox.y + object.collisionBox.height - offsetY
        end
        entity.updateCollisionBox()
    end
end

return collisionBox