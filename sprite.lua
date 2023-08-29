local love = require("love")
local animation = require("animation")

local sprite = {}

--- Creates a new sprite
-- @param spriteSheetPath path to the sprite sheet
-- @param width width of the sprite
-- @param height height of the sprite
-- @param duration duration of the animation
-- @param frames number of frames in the animation

function sprite.new(spriteSheetPath, width, height, duration, frames)

    local self = {}
    if frames == nil then
        frames = 0
    end

    local spriteImg = love.graphics.newImage(spriteSheetPath)
    self.animation = animation.new(spriteImg, width, height, duration, frames)

    self.draw = function(x, y)
        local frame = math.floor(self.animation.currentTime / self.animation.duration * #self.animation.quads) + 1
        love.graphics.draw(self.animation.spriteSheet, self.animation.quads[frame], x, y)

    end
    return self
end
return sprite
