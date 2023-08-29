local love = require("love")
local utils = require("utils")
local background = require("background")

local sprite = require("sprite")


if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

local text = "Here we start our demo"
local player = {}
local ct = 0
local showDebugInfo = false

local catSprite = {}
local mooseSprite = {}
local bgPic = {}

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

        -- print player position x
        love.graphics.print("Player: " .. player.x, 0, 40)

        -- print player position y
        love.graphics.print("Player: " .. player.y, 0, 60)


    end

    catSprite.draw(player.x, player.y)

end

function love.keypressed( key )
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
    player.x = player.x + dt*40
    player.y = math.sin(ct)*200+200
    if player.x > 800  then 
        player.x = -90 
    end
end
