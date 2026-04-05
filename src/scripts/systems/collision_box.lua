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

function collisionBox.create(entity, type)
    
    local _x
    local _y
    local _width
    local _height
    local _type

    --Ancho y alto

    collisionBox.width = entity.width * entity.scale

    if type == collisionBox.TYPES.BOTTOM or type == collisionBox.TYPES.TOP then
        _height = (entity.height * entity.scale) / 3
    elseif type == collisionBox.TYPES.FULL then
        _height = entity.height * entity.scale
    end

    --Posicion x e y

    collisionBox.x = entity.x

    if type == collisionBox.TYPES.FULL or type == collisionBox.TYPES.TOP then
        _y = entity.y
    elseif type == collisionBox.TYPES.BOTTOM then
        _y = entity.y + entity.height - (entity.height / 3)
    end

    --Definir tipo de collision box
    if type == collisionBox.TYPES.BOTTOM then
        _type = collisionBox.TYPES.BOTTOM
    elseif type == collisionBox.TYPES.TOP then
        _type = collisionBox.TYPES.TOP
    elseif type == collisionBox.TYPES.FULL then
    _type = collisionBox.TYPES.FULL
    end

    --Crearla
    entity.collisionBox = {
        width = entity.width,
        height = _height,
        x = entity.x,
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
    
    --Posicion x e y

    entity.collisionBox.x = entity.x

    if entity.type == collisionBox.TYPES.FULL or entity.type  == collisionBox.TYPES.TOP then
        entity.collisionBox.y = entity.y
    elseif entity.type == collisionBox.TYPES.BOTTOM then
        entity.collisionBox.y = entity.y + entity.height - (entity.height / 3)
    end
    
end

function collisionBox.resolveX(entity, object)

    if entity.collisionBox.check(entity, object) then
        if entity.collisionBox.x < object.collisionBox.x then
           entity.x = object.collisionBox.x - entity.width
        else
            entity.x = object.collisionBox.x + object.collisionBox.width
        end
    end

    entity.collisionBox.updatePosition(entity)
end

function collisionBox.resolveY(entity, object)
    
    if entity.collisionBox.check(entity, object) then

        if entity.collisionBox.y < object.collisionBox.y then
            entity.y = object.collisionBox.y - entity.height
        else
            if entity.type == collisionBox.TYPES.BOTTOM then
                entity.y = object.collisionBox.y + object.collisionBox.height - entity.height + entity.collisionBox.height                 
            else
                entity.y = object.y + object.collisionBox.height
            end
        end
    end
end

return collisionBox