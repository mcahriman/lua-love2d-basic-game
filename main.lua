local love = require("love")
local utils = require("utils")
local background = require("background")

local sprite = require("sprite")

if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

local text = "Here we start our demo"
local happyCat = {
    x = 0,
    y = 0,
    velocity = {
        x = 0,
        y = 0
    },
    size = 104
}
local gravity = 9.81
local gravityCoef = 100
local ct = 0
local showDebugInfo = false

local catSprite = {}
local mooseSprite = {}
local bgPic = {}

local mooseX = 0
local score = 0

function love.load()
    happyCat.x = 200
    happyCat.y = 200
    happyCat.size = 40

    local music = love.audio.newSource("assets/sounds/happy.mp3", "stream")
    music:setVolume(1)
    -- music:setPitch(0.5)
    music:setLooping(true)
    music:play()
    bgPic = background.new("assets/bg.jpg")
    mooseSprite = sprite.new("assets/sprites/moose.png", 200, 200, 5, 4)
    catSprite = sprite.new("assets/sprites/happyCat.png", 104, 112, 3, 72)

end

function love.draw()
    -- draw background
    bgPic.draw()

    -- draw debug info
    if showDebugInfo then
        love.graphics.print(text, 400, 0)

        -- print fps
        love.graphics.print("FPS:" .. love.timer.getFPS(), 0, 0)

        -- print mouse position
        local x, y = love.mouse.getPosition()
        love.graphics.print("Mouse: " .. x .. ", " .. y, 0, 20)

        -- print happyCat position x
        love.graphics.print("Player: " .. happyCat.x, 0, 40)

        -- print happyCat position y

        love.graphics.print("Player: " .. happyCat.y, 0, 60)

    end

    -- draw score with big font in top middle
    love.graphics.setFont(love.graphics.newFont(50))
    
    love.graphics.print(score, love.graphics.getWidth() / 2 - 50, 0)

    -- reset font
    love.graphics.setFont(love.graphics.newFont(12))

    catSprite.draw(happyCat.x, happyCat.y)

    local mooseWidth = 200
    local screenW = love.graphics.getWidth()

    mooseX = math.max(0, math.min(love.mouse.getX() - mooseWidth / 2, screenW - mooseWidth))

    mooseSprite.draw(mooseX, love.graphics.getHeight() - 200)

end

function love.keypressed(key)
    local splittedtext = utils.split(text, "\n")
    table.insert(splittedtext, key)
    text = table.concat(utils.lastn(splittedtext, 5), "\n")

    -- on escape quit
    if key == "escape" then
        love.event.quit()
    end

    -- on f12 toggle debug info
    if key == "f12" then
        showDebugInfo = not showDebugInfo
    end
end

function love.update(dt)

    catSprite.animation.passtime(dt)
    mooseSprite.animation.passtime(dt)
    ct = ct + dt

    local prevVelocity = happyCat.velocity.y

    -- move happyCat
    happyCat.x = happyCat.x + happyCat.velocity.x * dt
    happyCat.y = happyCat.y + happyCat.velocity.y * dt

    -- apply gravity
    happyCat.velocity.y = happyCat.velocity.y + gravity * gravityCoef * dt


    -- bounce from walls
    if happyCat.x > love.graphics.getWidth() - happyCat.size then
        happyCat.x = love.graphics.getWidth() - happyCat.size
        happyCat.velocity.x = -happyCat.velocity.x * 0.8
    end

    if happyCat.x < 0 then
        happyCat.x = 0
        happyCat.velocity.x = -happyCat.velocity.x
    end

    -- hitbox for moose
    local mooseWidth = 200
    local mooseHeight = 200

    -- is moose hit by happyCat?
    if utils.isPointInRect(happyCat.x, happyCat.y, mooseX, love.graphics.getHeight() - mooseHeight, mooseWidth, mooseHeight) then
        -- bounce from moose
        happyCat.velocity.y = -math.abs(happyCat.velocity.y)
        happyCat.velocity.x = happyCat.velocity.x + math.random(-100, 100)
    end

    -- if did not hit moose, reset falling speed and happyCat position to random direction
    if happyCat.y > love.graphics.getHeight() - happyCat.size then
        happyCat.y =  happyCat.size
        happyCat.x = math.random(0, love.graphics.getWidth() - happyCat.size)
        happyCat.velocity.y = 0
        happyCat.velocity.x = math.random(-200, 200)
    end

    -- if velocity has reversed, add score
    if prevVelocity > 0 and happyCat.velocity.y < 0 then
       score = score + 1
    end


end
