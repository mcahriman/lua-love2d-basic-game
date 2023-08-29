local love = require("love")
local utils = require("utils")
local background = require("background")

local sprite = require("sprite")


if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

local text = "Here we start our demo"
local happyCat = {}
local player = {}
local ct = 0
local shader1 = {}

local bgPic = {}
local catSprite = {}
local mooseSprite = {}

function love.load() 
    player.x = 200
    player.y = 200
    player.size = 40

    local music = love.audio.newSource("assets/sounds/happy.mp3", "stream")
    music:setVolume(1)
    -- music:setPitch(0.5)
    music:setLooping(true)
    -- music:play()

    bgPic = background.new("assets/bg.jpg")

    shader1 = love.graphics.newShader("shaders/wobbly.glsl")

    mooseSprite = sprite.new("assets/sprites/moose.png", 200, 200, 5, 4)
    -- happyCat = animation.new(happyImg, 104, 112, 3, 72)
    catSprite = sprite.new("assets/sprites/happyCat.png", 104, 112, 3, 72)

end

function love.draw()
    -- draw background


    bgPic.draw()
    mooseSprite.draw(100,100)

    love.graphics.print(text, 400, 0)
    -- print ct in right corner 200 px from right even if resized
    love.graphics.print(ct, love.graphics.getWidth()-200, 0)

    -- print fps
    love.graphics.print(love.timer.getFPS(), 0, 0)

    -- love.graphics.setShader(shader1)

    -- love.graphics.draw(happyImg, player.x ,player.y, 50)
    -- draw specific animation quad
    -- local spriteNum = math.floor(happyCat.currentTime / happyCat.duration * #happyCat.quads) + 1
    -- love.graphics.draw(happyCat.spriteSheet, happyCat.quads[spriteNum], player.x, player.y)

    catSprite.draw(player.x, player.y)

    -- love.graphics.setShader()
end

function love.keypressed( key )
    local splittedtext = utils.split(text, "\n")
    table.insert(splittedtext, key)
    text = table.concat(utils.lastn(splittedtext, 5), "\n")

    -- on escape quit
    if key == "escape" then
        love.event.quit()
    end
end

function love.update(dt)

    -- get mouse position
    local x, y = love.mouse.getPosition()
    -- local prev_x, prev_y = x, y
    -- local dx, dy = x - prev_x, y - prev_y
    -- local velocity_x, velocity_y = dx / dt, dy / dt

    catSprite.animation.passtime(dt)
    mooseSprite.animation.passtime(dt)


    ct = ct + dt
    player.x = player.x + dt*40
    player.y = math.sin(ct)*200+200
    if player.x > 800  then 
        player.x = -90 
    end
     
    -- shader1.send( shader1, "time", ct )
    -- shader1.send(shader1, "dimY", 20)

    -- shader1.send(shader1, "distortionX", 2)
    -- -- send mouse position to shader
    -- shader1.send(shader1, "mouseX", x)
    -- shader1.send(shader1, "mouseY", y)
    -- -- send resolution to shader
    -- shader1.send(shader1, "resX", love.graphics.getWidth())
    -- shader1.send(shader1, "resY", love.graphics.getHeight())

end
