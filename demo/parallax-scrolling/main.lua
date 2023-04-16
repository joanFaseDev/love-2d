push = require 'lib.push'

-- Game's fixed resolution
GAME_WIDTH = 768
GAME_HEIGHT = 432

-- Resolution of the window one need to adapt the game to
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- The closer the layer, the higher its speed
-- Looping points aren't arbitrary values but precise ones that target the x coordinates where the image loops on itsef
foreGroundScrollX = 0
FOREGROUND_SCROLL_SPEED = 60
FOREGROUND_LOOPING_POINT = 404

middleGroundScrollX = 0
MIDDLEGROUND_SCROLL_SPEED = 30
MIDDLEGROUND_LOOPING_POINT = 437

farGroundScrollX = 0
FARGROUND_SCROLL_SPEED = 10
FARGROUND_LOOPING_POINT = 427

local background = love.graphics.newImage('assets/background.png')
local farGround = love.graphics.newImage('assets/farGround.png')
local foreGround = love.graphics.newImage('assets/foreGround.png')
local middleGround = love.graphics.newImage('assets/middleGround.png')

function love.load()
    -- Set filter so that upscale/downscale don't blurry pixelart (that way it stays crisp)
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Parallax Scrolling Demo')

    -- Initialize the push library, setting the fixed resolution
    push:setupScreen(GAME_WIDTH, GAME_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
end

function love.update(dt)
    --[[
        Layer's position increase gradually until it reaches the looping point's value. Then the modulo operator reset the value to 0 therefore creating a perfect loop
    ]]
    farGroundScrollX = (farGroundScrollX + FARGROUND_SCROLL_SPEED * dt) % FARGROUND_LOOPING_POINT
    middleGroundScrollX = (middleGroundScrollX + MIDDLEGROUND_SCROLL_SPEED * dt) % MIDDLEGROUND_LOOPING_POINT
    foreGroundScrollX = (foreGroundScrollX + FOREGROUND_SCROLL_SPEED * dt) % FOREGROUND_LOOPING_POINT
end

function love.draw()
    push:start()

    love.graphics.draw(background, 0, 0)
    -- Layers are moving backward to give the illusion of movement
    love.graphics.draw(farGround, -farGroundScrollX, GAME_HEIGHT - farGround:getHeight())
    love.graphics.draw(middleGround, -middleGroundScrollX, GAME_HEIGHT - middleGround:getHeight())
    love.graphics.draw(foreGround, -foreGroundScrollX, GAME_HEIGHT - foreGround:getHeight())

    push:finish()
end

function love.resize(w, h)
    -- Enable push library to takes into account window resizing
    push:resize(w, h)
end

function love.keypressed(key)
    -- Press the escape key to quit the game
    if key == 'escape' then
        love.event.quit()
    end
end