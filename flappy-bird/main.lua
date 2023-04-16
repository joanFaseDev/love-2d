push = require 'push' 

WINDOW_WIDTH = 1280
WINDOW_HEIGTH = 720

-- 16 by 9 for 32 pixels sprite
VIRTUAL_WIDTH = 512 -- 32 * 16 = 512
VIRTUAL_HEIGHT = 288 -- 32 * 9 = 288

-- Local variables cannot be accessed in other files
local background = love.graphics.newImage('assets/images/background.png') -- 1157 * 288
local ground = love.graphics.newImage('assets/images/ground.png')

-- Position X of each image
local backgroundScrollX = 0
local groundScrollX = 0

-- Scrolling speed of each image
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

--[[ 
    413 isn't an arbitrary value, it's the exact point where the pattern of the image's far left side starts again therefore forming an uninterrupted loop.
]]
local BACKGROUND_LOOPING_POINT = 413

-- Is called at the beginning of the love's program execution
function love.load()
    -- Apply nearest default filtering on upscale and downscale which means crisp pixel art and less bluriness
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Flappy Bird')

    -- Initialize push by giving it the game's fixed resolution and the resolution of the window the game needs to adapt
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGTH, { 
        vsync = true,
        fullscreen = false, 
        resizable = true  
    })
end

function love.update(dt)
    --[[ 
        Once the scrolling X values reach their looping point value the modulo operator will return 0 therefore reinitializing the scrolling X values and creating a perfect loop for the background/ground
    ]]
    backgroundScrollX = (backgroundScrollX + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScrollX = (groundScrollX + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
end

function love.draw()
    push:start()

    --[[ 
        Background and ground's x axe is negative so to be directed in the opposite direction of the player therefore creating the illusion of movement
    ]]
    love.graphics.draw(background, -backgroundScrollX, 0)
    love.graphics.draw(ground, -groundScrollX, VIRTUAL_HEIGHT - ground:getHeight())

    push:finish()
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    -- Press Escape to quit the game
    if key == 'escape' then
        love.event.quit()
    end
end