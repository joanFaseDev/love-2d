--[[ 
    if the module passed is a lua file then .lua shouldn't be used
    use period to separate folders instead of forward slashes (work but only accidently)
]]
push = require 'libraries.push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

TITLE = "Welcome Pong!"
FONT_AUDIOWIDE = 'assets/fonts/Audiowide-Regular.ttf'
FONT_PRESSSTART = 'assets/fonts/PressStart2P-Regular.ttf'

titleWidth = nil
titleHeight = nil

PADDLEWIDTH = 5
PADDLEHEIGHT = 20
PADDLESPEED = 200

BALLWIDTH = 4
BALLHEIGHT = 4


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
                
    -- setNewFont() combines creating/setting a new font but only works with TTF fonts
    -- FONT = love.graphics.setNewFont(FONT_PRESSSTART, 30)
    FONT = love.graphics.newFont(FONT_PRESSSTART, 8)
    SCOREFONT = love.graphics.newFont(FONT_PRESSSTART, 24)

    titleWidth = FONT:getWidth(TITLE)
    titleHeight = FONT:getHeight(TITLE)
    
    -- Initialize the virtual resolution which will be rendered within the actual window
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    -- Initialize player's score and vertical position on screen (horizontal position is fixed for players cannot move horizontally)
    p1Score = 0
    p2Score = 0
    p1StartY = 30
    p2StartY = VIRTUAL_HEIGHT - (PADDLEHEIGHT + 30)

    -- Initialize ball's position to the center of the screen
    ballStartX = VIRTUAL_WIDTH / 2 - BALLWIDTH / 2
    ballStartY = VIRTUAL_HEIGHT / 2 - BALLHEIGHT / 2

    -- Lua's version of a ternary operator use and / or logical operators
    ballDX = math.random(2) == 1 and 100 or -100
    ballDY = math.random(-50, 50)

    -- gamestate variable is used to transition between different parts of the game and determine behavior during update/draw (render)
    gamestate = 'start'
    
end

function love.update(dt)
    -- Update Player 1 vertical movement
    --[[
        math.min and math.max are used to clamp the players movement so that they cannot go beyond the limits of the screen
    ]]
    if love.keyboard.isDown('w') then
        p1StartY = math.max(0, p1StartY + -PADDLESPEED * dt)
    elseif love.keyboard.isDown('s') then
        p1StartY = math.min(VIRTUAL_HEIGHT - PADDLEHEIGHT, p1StartY + PADDLESPEED * dt)
    end

    -- Update Player 2 vertical movement
    if love.keyboard.isDown('up') then
        p2StartY = math.max(0, p2StartY + -PADDLESPEED * dt)
    elseif love.keyboard.isDown('down') then
        p2StartY = math.min(VIRTUAL_HEIGHT - PADDLEHEIGHT, p2StartY + PADDLESPEED * dt)
    end

    -- Update the ball based on its deltaX and deltaY but only if in the right game state
    if gamestate == 'play' then
        ballStartX = ballStartX + ballDX * dt
        ballStartY = ballStartY + ballDY * dt
    end
end

function love.draw()
    -- Apply the virtual resolution
    push:apply('start')

    -- Clear the screen to a specified color
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)
    -- To change font color, add a table as a first argument like this {{r, g, b, a}, string1, {r, g, b, a}, string2, ...}

    love.graphics.setFont(FONT)
    if gamestate == 'start' then
        TITLE = 'Welcome Start State!'
    else
        TITLE = 'Welcome Play State!'
    end
    love.graphics.printf(TITLE, 0 , titleHeight, VIRTUAL_WIDTH, 'center')

    -- Change font to render players' scores
    -- love.graphics.setFont(SCOREFONT)
    -- love.graphics.print(tostring(p1Score), VIRTUAL_WIDTH / 2 - (30 + SCOREFONT:getWidth(tostring(p1Score))), VIRTUAL_HEIGHT / 3)
    -- love.graphics.print(tostring(p2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)    

    -- Render paddle left
    love.graphics.rectangle('fill', 10, p1StartY, PADDLEWIDTH, PADDLEHEIGHT)
    -- Render paddle right
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - (10 + PADDLEWIDTH), p2StartY, PADDLEWIDTH, PADDLEHEIGHT)
    -- Render ball
    love.graphics.rectangle('fill', ballStartX, ballStartY, BALLWIDTH, BALLHEIGHT)

    push:apply('end')
end
  
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gamestate == 'start' then 
            gamestate = 'play'
        else
            -- In 'start' state, reinitialize the ball's position and randomly set its x and y velocity
            gamestate = 'start'
            ballStartX = VIRTUAL_WIDTH / 2 - BALLWIDTH / 2
            ballStartY = VIRTUAL_HEIGHT / 2 - BALLHEIGHT / 2
            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50) * 1.5
        end
    end
end
