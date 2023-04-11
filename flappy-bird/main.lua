push = require 'push' 

WINDOW_WIDTH = 1280
WINDOW_HEIGTH = 720

-- 16 by 9 for 32 pixels sprite
VIRTUAL_WIDTH = 512 -- 32 * 16 = 512
VIRTUAL_HEIGHT = 288 -- 32 * 9 = 288

-- local variables cannot be accessed in other files
local background = love.graphics.newImage('assets/images/background.png')
local ground = love.graphics.newImage('assets/images/ground.png')

-- is called at the beginning of the love's program execution
function love.load()
    -- apply nearest default filtering on upscale and downscale which means crisp pixel art and less bluriness
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Flappy Bird')

    -- initialize push by giving it the game's fixed resolution and the resolution of the window the game needs to adapt
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGTH, { 
        vsync = true,
        fullscreen = false, 
        resizable = true  
    })
end

function love.draw()
    push:start()

    love.graphics.draw(background, 0, 0)
    love.graphics.draw(ground, 0, VIRTUAL_HEIGHT - ground:getHeight())
    print(ground:getHeight())

    push:finish()
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end