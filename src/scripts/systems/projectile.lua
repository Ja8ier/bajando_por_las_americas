local GRAVITY = 400
local WORLD_WIDTH

local angle = 30
local initialX = 0
local initialY = 0
local groundY = 0
local groundX = 0

local projectile = {
    x = 0,
    y = 0,
    vy = 0,
    vx = 0,
    width = 0,
    height = 0,
    power = 0,
    isActive = false,
    bounced = false,
    image = { sprite = "", scale = 1 },
    objWidth = 0,
    objHeight = 0
}

local facingLeftOneTime = true
local facingLeft

function projectile.new(power, direction, _initialX, _initialY, finalY, bounced, _image, _scale, worldWidth, objWidth, objHeight)

    projectile.x = _initialX
    projectile.y = _initialY
    projectile.vx = 0
    projectile.vy = 0
    groundX = 0
    facingLeftOneTime = true

    projectile.power = power
    angle = math.rad(direction)
    initialX = _initialX
    initialY = _initialY
    groundY = finalY
    projectile.bounced = bounced
    projectile.image.sprite = _image
    projectile.image.scale = _scale
    WORLD_WIDTH = worldWidth
    projectile.objWidth = objWidth or 0
    projectile.objHeight = objHeight or 0
    return projectile
end

function projectile.getGroundX()
    return groundX
end

function projectile.getGroundY()
    return groundY
end

function projectile.load()

end


function projectile.update(dt, _facingLeft)

    if facingLeftOneTime then
        facingLeft = _facingLeft    
        facingLeftOneTime = false
    end

    local time = dt * 1.5
    if projectile.isActive then

        projectile.vy = projectile.vy + GRAVITY * time
        if facingLeft then
            projectile.x = projectile.x - projectile.vx * time
        else
            projectile.x = projectile.x + projectile.vx * time
        end
        projectile.y = projectile.y + projectile.vy * time

        -- condiciones de rebote y destrucción
        if projectile.y >= groundY then
            projectile.isActive = false
            groundX = projectile.x
            if projectile.bounced then
                projectile.y = groundY
            end
        end

        if projectile.bounced and (projectile.x + projectile.width > WORLD_WIDTH or projectile.x < 0) then
            projectile.vx = -projectile.vx
        end
    end

end

function projectile.draw()
    love.graphics.draw(projectile.image.sprite, projectile.x, projectile.y, 0, projectile.image.scale, projectile.image.scale)
end

function projectile.throw()

    if not projectile.active then
        projectile.active = true
        projectile.x = initialX
        projectile.y = initialY
        projectile.vx = projectile.power * math.cos(angle)
        projectile.vy = -projectile.power * math.sin(angle)
    end

end

function projectile.reset()
    projectile.isActive = false
    projectile.active = false
    projectile.x = 0
    projectile.y = 0
    projectile.vx = 0
    projectile.vy = 0
    groundX = 0
    groundY = 0
    facingLeftOneTime = true
end

return projectile