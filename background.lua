local love = require("love")

local background = {}

function background.new(picture)
    local self = {}

    local rippleShader = love.graphics.newShader("shaders/ripple.glsl")

    self.picture = love.graphics.newImage(picture)

    function self.draw()
        local x, y = love.mouse.getPosition()
        rippleShader:send("mousePosition", {x, y})
        rippleShader:send("time", love.timer.getTime())
        rippleShader:send("resolution", {love.graphics.getWidth(), love.graphics.getHeight()})
    
        love.graphics.setShader(rippleShader)
        love.graphics.draw(self.picture, 0, 0)
        love.graphics.setShader()
        
    end

    return self
end

return background