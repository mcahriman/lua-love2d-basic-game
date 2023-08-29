local love = require("love")

local animation = {}

function animation.new (image, width, height, duration, frameCount)
    if frameCount == nil then
        frameCount = 0
    end
    local instance = {}
    instance.spriteSheet = image;
    instance.quads = {};

    -- break it into quads
    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(instance.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
            -- for the case of a sprite sheet with framescount < total quad count in sheet
            if frameCount > 0 and #instance.quads == frameCount then
                break
            end
        end
    end

    instance.duration = duration or 1
    instance.currentTime = 0

    function instance.passtime(dt)
        instance.currentTime = instance.currentTime + dt
        if instance.currentTime >= instance.duration then
            instance.currentTime = instance.currentTime - instance.duration
        end
    end
    
    return instance
end

return animation