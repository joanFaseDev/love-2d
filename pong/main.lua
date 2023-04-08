--[[ 
    if the module passed is a lua file then .lua shouldn't be used
    use period to separate folders instead of forward slashes (work but only accidently)
]]
push = require 'libraries.push'
Object = require 'libraries.classic'

require 'scenes.Ball'
require 'scenes.Paddle'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

TITLE = "Welcome Pong!"
FONT_AUDIOWIDE = 'assets/fonts/Audiowide-Regular.ttf'
FONT_PRESSSTART = 'assets/fonts/PressStart2P-Regular.ttf'

titleWidth = nil
titleHeight = nil




--[[
    Runs when the game first starts up, only once; used to initialize the game
]]
function love.load()

    -- Sets a seed for the pseudo random generator. By using Unix time as seed, one makes sure that the random generator is truly random 
    print(os.time())
    math.randomseed(os.time())
--[[ 
    This function does not apply retroactively to loaded images.
    Already existing objects retain their current scaling filters
]]
    love.graphics.setDefaultFilter('nearest', 'nearest')
       
    -- Create players and ball's instances. Initialize their positions.
    player1 = Paddle(10, 30)
    player2 = Paddle(VIRTUAL_WIDTH - (10 + 5), VIRTUAL_WIDTH - (30 + 20))
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2)

    -- setNewFont() combines creating/setting a new font but only works with TTF fonts
    -- FONT = love.graphics.setNewFont(FONT_PRESSSTART, 30)
    FONT = love.graphics.newFont(FONT_PRESSSTART, 8)
    SCOREFONT = love.graphics.newFont(FONT_PRESSSTART, 24)

    sounds = {
        ['paddle-hit'] = love.audio.newSource('assets/sounds/paddle-hit.wav', 'static'),
        ['wall-hit'] = love.audio.newSource('assets/sounds/wall-hit.wav', 'static'),
        ['score'] = love.audio.newSource('assets/sounds/score.wav', 'static')
    }

    titleWidth = FONT:getWidth(TITLE)
    titleHeight = FONT:getHeight(TITLE)
    
    -- Initialize the virtual resolution which will be rendered within the actual window
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    -- Initialize player's score 
    p1Score = 9
    p2Score = 9

    -- Have a value of either 1 or 2 which corresponds to the player that is actually serving
    servingPlayer = 1

    -- gameState variable is used to transition between different parts of the game and determine behavior during update/draw (render)
    gameState = 'start'
    
end

-- Called by love2d whenever the screen is resized, here it is used to pass the width and height to push's method resize
function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    -- Before switching to 'play' state, initialize the ball's velocity based on the player who have the serve
    if gameState == 'serve' then
        ball.dY = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dX = math.random(140, 200)
        else
            ball.dX = -math.random(140, 200)
        end
    elseif gameState == 'play' then
        if ball:collision(player1) then
            --[[
                If collision, return the ball into the opposite direction and slightly increase its speed.
                Also immediately change the ball x position to the right edge of the player1 to prevent the ball being stuck 'inside' the player
            ]]
            ball.dX = -ball.dX * 1.03
            ball.x = player1.x + player1.width

            -- Keep the velocity in the same vertical direction but randomize it
            if ball.dY < 0 then
                ball.dY = -math.random(10, 150)
            else
                ball.dY = math.random(10, 150)
            end

            sounds['paddle-hit']:play()
        end

        if ball:collision(player2) then
            ball.dX = -ball.dX * 1.03
            ball.x = player2.x - ball.width

            if ball.dY < 0 then
                ball.dY = -math.random(10, 150)
            else
                ball.dY = math.random(10, 150)
            end

            sounds['paddle-hit']:play()
        end

        --[[
            Check for top and bottom screen's edge collision. If true, reverse the direction so the ball go the opposite way.
        ]]
        if ball.y <= 0 then
            ball.y = 0
            ball.dY = -ball.dY
            sounds['wall-hit']:play()
        end

        if ball.y > VIRTUAL_HEIGHT - ball.height then
            ball.y = VIRTUAL_HEIGHT - ball.height
            ball.dY = -ball.dY
            sounds['wall-hit']:play()
        end

        --[[ 
            Each time a player fail to send back the ball, the other one score a point. Losing player get the serve, ball's position is reset and game's state is changed.
        ]]
        if ball.x < 0 then
            servingPlayer = 1
            p2Score = p2Score + 1
            sounds['score']:play()
            if p2Score == 10 then
                winningPlayer = 2
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end

        if ball.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            p1Score = p1Score + 1
            sounds['score']:play()
            if p1Score == 10 then
                winningPlayer = 1
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end 
        end
    end
    -- Update Player 1 vertical movement
    if love.keyboard.isDown('w') or love.keyboard.isDown('z') then
        player1.dY = -player1.speed
    elseif love.keyboard.isDown('s') then
        player1.dY = player1.speed
    else
        player1.dY = 0
    end

    -- Update Player 2 vertical movement
    if love.keyboard.isDown('up') then
        player2.dY = -player2.speed
    elseif love.keyboard.isDown('down') then
        player2.dY = player2.speed
    else
        player2.dY = 0
    end

    -- Update the ball based on its deltaX and deltaY but only if in the right game state
    if gameState == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end

function love.draw()
    -- Apply the virtual resolution
    push:apply('start')

    -- Clear the screen to a specified color
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)
    -- To change font color, add a table as a first argument like this {{r, g, b, a}, string1, {r, g, b, a}, string2, ...}

    love.graphics.setFont(FONT)

    displayScore()

    -- Render different helping messages to the players depending of the game stage
    if gameState == 'start' then
        love.graphics.setFont(FONT)
        love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(FONT)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. '\'s serve!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        -- no message yet
    elseif gameState == 'done' then
        love.graphics.setFont(SCOREFONT)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' won!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(FONT)
        love.graphics.printf('Press enter to restart!', 0, 50, VIRTUAL_WIDTH, 'center')
    end

    -- Render paddle left
    player1:render()
    -- Render paddle right
    player2:render()
    -- Render ball
    ball:render()

    displayFPS()
    
    push:apply('end')
end
  
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then 
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'done' then
            gameState = 'serve'
            ball:reset()
            -- Reset both players score
            p1Score = 0
            p2Score = 0
            -- Next serve is given to the opponent of the previous winner
            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end
    end
end

-- Render actual frames per second in the left upper side of the screen
function displayFPS()
    love.graphics.setFont(FONT)
    love.graphics.setColor(0 / 255, 255 / 255, 0 / 255, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

-- Render the two player's scores
function displayScore()
    -- Change font to render players' scores
    love.graphics.setFont(SCOREFONT)
    love.graphics.print(tostring(p1Score), VIRTUAL_WIDTH / 2 - (30 + SCOREFONT:getWidth(tostring(p1Score))), VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(p2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)  
end
