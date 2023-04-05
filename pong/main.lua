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
    print(player1, player2)
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2)

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

    -- Initialize player's score 
    p1Score = 0
    p2Score = 0

    -- gamestate variable is used to transition between different parts of the game and determine behavior during update/draw (render)
    gamestate = 'start'
    
end

function love.update(dt)
    -- Update Player 1 vertical movement
    if love.keyboard.isDown('w') then
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
    if gamestate == 'play' then
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
    player1:render()
    -- Render paddle right
    player2:render()
    -- Render ball
    ball:render()
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
            ball:reset()
        end
    end
end
