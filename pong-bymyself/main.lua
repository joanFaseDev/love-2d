push = require('libraries.push')
Object = require('libraries.classic')
require('scenes.Paddle')
require('scenes.Ball')



-- Resolution of the window the game needs to adapt to
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Fixed resolution
GAME_WIDTH = 432
GAME_HEIGHT = 243

-- Font && Text
FONT_SIZE_TITLE = 16
FONT_SIZE_DEFAULT = 14
TEXT_GREETINGS = 'Welcome to Pong!'
TEXT_START = 'Press ENTER to serve!'

function love.load()
    -- Set the default scaling filter to better fit pixel art (could be blurry by default)
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(GAME_WIDTH, GAME_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, { fullscreen = false, resizable = false })
    
    -- Load font assets
    fontTitle = love.graphics.newFont('assets/fonts/DotGothic16-Regular.ttf', FONT_SIZE_TITLE)
    fontDefault = love.graphics.newFont('assets/fonts/DotGothic16-Regular.ttf', FONT_SIZE_DEFAULT)

    -- Load players and ball
    p1 = Paddle(0, GAME_HEIGHT - PLAYER_HEIGHT)
    p2 = Paddle(GAME_WIDTH - PLAYER_WIDTH, 0)
    ball = Ball(GAME_WIDTH / 2 - BALL_WIDTH / 2, GAME_HEIGHT / 2 - BALL_HEIGHT / 2)
end

function love.update(dt)

end

function love.draw()
    -- Apply transformation from the push library (fixed resolution)
    push:apply('start')

    -- Clear the screen each frame and set up a gray background
    love.graphics.clear(33 / 255, 37 / 255, 41 / 255, 1)

    -- Game state START
    -- Font && Text
    love.graphics.setFont(fontTitle)
    love.graphics.printf(TEXT_GREETINGS, 0, FONT_SIZE_TITLE, GAME_WIDTH, 'center')
    love.graphics.setFont(fontDefault)
    love.graphics.printf(TEXT_START, 0, FONT_SIZE_TITLE * 2 + FONT_SIZE_DEFAULT, GAME_WIDTH, 'center')

    -- Players && Ball
    p1:draw()
    p2:draw()
    ball:draw()

    push:apply('end')
end

function love.keypressed(key)
    -- Press Escape key to quit the game
    if key == 'escape' then
        love.event.quit()
    end
end