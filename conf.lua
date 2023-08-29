local love = require("love")

function love.conf(t)
    t.window.width = 800
    t.window.height = 600
    t.window.resizable = true
    t.window.title = "Love2D Shader Example"
end