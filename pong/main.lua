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
    
end

function love.update(dt)
    -- Update Player 1 vertical movement
    if love.keyboard.isDown('w') then
        p1StartY = p1StartY - PADDLESPEED * dt
    elseif love.keyboard.isDown('s') then
        p1StartY = p1StartY + PADDLESPEED * dt
    end

    -- Update Player 2 vertical movement
    if love.keyboard.isDown('up') then
        p2StartY = p2StartY - PADDLESPEED * dt
    elseif love.keyboard.isDown('down') then
        p2StartY = p2StartY + PADDLESPEED * dt
    end

end

function love.draw()
    -- Apply the virtual resolution
    push:apply('start')

    -- Clear the screen to a specified color
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)
    -- To change font color, add a table as a first argument like this {{r, g, b, a}, string1, {r, g, b, a}, string2, ...}

    love.graphics.setFont(FONT)
    love.graphics.printf(TITLE, 0 , titleHeight, VIRTUAL_WIDTH, 'center')

    -- Change font to render players' scores
    love.graphics.setFont(SCOREFONT)
    love.graphics.print(tostring(p1Score), VIRTUAL_WIDTH / 2 - (30 + SCOREFONT:getWidth(tostring(p1Score))), VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(p2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)    

    -- Render paddle left
    love.graphics.rectangle('fill', 10, p1StartY, PADDLEWIDTH, PADDLEHEIGHT)
    -- Render paddle right
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - (10 + PADDLEWIDTH), p2StartY, PADDLEWIDTH, PADDLEHEIGHT)
    -- Render ball
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - BALLWIDTH / 2, VIRTUAL_HEIGHT / 2 - BALLHEIGHT / 2, BALLWIDTH, BALLHEIGHT)

    push:apply('end')
end
  
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end
