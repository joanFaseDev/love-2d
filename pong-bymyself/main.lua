push = require('libraries.push')
Object = require('libraries.classic')
require('scenes.Paddle')
require('scenes.Ball')

-- Variable whose value determine what actions are possible in the game
gameState = 'start'

-- Identify the next player to serve (player 1 by default)
servingPlayer = 1

-- Resolution of the window the game needs to adapt to
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Fixed resolution
GAME_WIDTH = 432
GAME_HEIGHT = 243

-- Font && Text
FONT_SIZE_TITLE = 16
FONT_SIZE_DEFAULT = 8
TEXT_GREETINGS = 'Welcome to Pong!'
TEXT_START = 'Press ENTER to start playing!'
TEXT_SERVE_PLAYER = 'Player ' .. tostring(servingPlayer) .. ' is serving!'
TEXT_SERVE = 'Press ENTER to serve!'



function love.load()
    -- Set the default scaling filter to better fit pixel art (could be blurry by default)
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    push:setupScreen(GAME_WIDTH, GAME_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, { fullscreen = false, resizable = false })
    
    -- Set a unique seed value every time the game starts (that way, math.random() truly return a random number)
    math.randomseed(os.time())

    -- Load font assets
    fontTitle = love.graphics.newFont('assets/fonts/PressStart2P-Regular.ttf', FONT_SIZE_TITLE)
    fontDefault = love.graphics.newFont('assets/fonts/PressStart2P-Regular.ttf', FONT_SIZE_DEFAULT)

    -- Load sound assets
    sounds = {
        ['hit-paddle'] = love.audio.newSource('assets/sounds/hit-paddle.wav', 'static'),
        ['out-of-bonds'] = love.audio.newSource('assets/sounds/out-of-bonds.wav', 'static'),
        ['score'] = love.audio.newSource('assets/sounds/score.wav', 'static')
    }

    -- Load players and ball
    p1 = Paddle(0, GAME_HEIGHT - PLAYER_HEIGHT, 'z', 's')
    p2 = Paddle(GAME_WIDTH - PLAYER_WIDTH, 0, 'up', 'down')
    ball = Ball(GAME_WIDTH / 2 - BALL_WIDTH / 2, GAME_HEIGHT / 2 - BALL_HEIGHT / 2)
end

function love.update(dt)
    -- -- Game state == 'serve'
    if gameState == 'serve' then
        p1:reset()
        p2:reset()
        ball:reset()
        -- Randomize the ball's vertical velocity + horizontal velocity (toward the opposite side of the serving player)
        ball.deltaY = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.deltaX = math.random(140, 200)
        elseif servingPlayer == 2 then
            ball.deltaX = -math.random(140, 200)
        end
    end
    
    -- Game state PLAY
    if gameState == 'play' then
        -- Player 1
        p1:move(dt)

        --[[ 
            If collision, reposition the ball just next to the colliding player. 
            Then send back the ball the opposite direction.
        ]]
        if p1:collide(ball) then
            sounds['hit-paddle']:play()
            ball.x = p1.x + p1.width
            ball.deltaX = -ball.deltaX * 1.04
            
            -- Randomize the vertical velocity but keeps the global direction
            if ball.deltaY < 0 then
                ball.deltaY = -math.random(10, 150)
            else
                ball.deltaY = math.random(10, 150)
            end
        end

        -- Player 2
        p2:move(dt)

        --[[ 
            If collision, reposition the ball just next to the colliding player. 
            Then send back the ball the opposite direction.
        ]]
        if p2:collide(ball) then
            sounds['hit-paddle']:play()
            ball.x = p2.x - ball.width
            ball.deltaX = -ball.deltaX * 1.04

            -- Randomize the vertical velocity but keeps the global direction
            if ball.deltaY < 0 then
                ball.deltaY = -math.random(10, 150)
            else
                ball.deltaY = math.random(10, 150)
            end
        end

        -- Ball
        ball:move(dt)
        ball:collide()

        if ball.x < 0 - ball.width then
            sounds['score']:play()
            p2.score = p2.score + 1
            servingPlayer = 1
            TEXT_SERVE_PLAYER = 'Player ' .. tostring(servingPlayer) .. ' is serving!'
            if p2.score == 10 then
                victor = 2
                gameState = 'victory'
            else
                gameState = 'serve'
            end
        end

        if ball.x >  GAME_WIDTH then
            sounds['score']:play()
            p1.score = p1.score + 1
            servingPlayer = 2
            TEXT_SERVE_PLAYER = 'Player ' .. tostring(servingPlayer) .. ' is serving!'
            if p1.score == 10 then
                victor = 1
                gameState = 'victory'
            else
                gameState = 'serve'
            end
        end
    end

    if gameState == 'victory' then
        p1.score = 0
        p2.score = 0
    end
end

function love.draw()
    -- Apply transformation from the push library (fixed resolution)
    push:apply('start')

    -- Clear the screen each frame and set up a gray background
    love.graphics.clear(33 / 255, 37 / 255, 41 / 255, 1)

    -- Game state START
    -- Font && Text
    if gameState == 'start' then
        love.graphics.setFont(fontTitle)
        love.graphics.printf(TEXT_GREETINGS, 0, FONT_SIZE_TITLE, GAME_WIDTH, 'center')
        love.graphics.setFont(fontDefault)
        love.graphics.printf(TEXT_START, 0, FONT_SIZE_TITLE * 2 + FONT_SIZE_DEFAULT, GAME_WIDTH, 'center')
    end

    -- Game state SERVE
    -- Font && Text
    if gameState == 'serve' then
        love.graphics.setFont(fontDefault)
        love.graphics.printf(TEXT_SERVE_PLAYER, 0, FONT_SIZE_TITLE, GAME_WIDTH, 'center')
        love.graphics.printf(TEXT_SERVE, 0, FONT_SIZE_TITLE * 2 + FONT_SIZE_DEFAULT, GAME_WIDTH, 'center')
        love.graphics.setFont(fontTitle)
        love.graphics.printf(tostring(p1.score), 0, GAME_HEIGHT / 2, GAME_WIDTH / 2, 'center')
        love.graphics.printf(tostring(p2.score), 0, GAME_HEIGHT / 2, GAME_WIDTH + GAME_WIDTH / 2, 'center')
    end

    -- Game state PLAY
    -- Middle separation
    if gameState == 'play' then
        love.graphics.rectangle('fill', GAME_WIDTH / 2 - 1, 0, 2, GAME_HEIGHT / 2 - 8)
        love.graphics.rectangle('fill', GAME_WIDTH / 2 - 1, GAME_HEIGHT / 2 + 8, 2, GAME_HEIGHT / 2 - 8)
    end

    -- Game state VICTORY
    -- Font && Text
    if gameState == 'victory' then
        love.graphics.setFont(fontTitle)
        love.graphics.printf('Player ' .. tostring(victor) .. ' won!', 0, FONT_SIZE_TITLE, GAME_WIDTH, 'center')
        love.graphics.setFont(fontDefault)
        love.graphics.printf('Press ENTER to start a new match!', 0, FONT_SIZE_TITLE * 2 + FONT_SIZE_DEFAULT, GAME_WIDTH, 'center')
    end

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

    -- Pressing Enter key has different effects depending the stage the game is in
    if key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'victory' then
            gameState = 'serve'
        end
    end
end