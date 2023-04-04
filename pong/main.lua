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

recWidth = 5
recHeight = 20
--[[
    Runs when the game first starts up, only once; used to initialize the game
]]
function love.load()
--[[ 
    This function does not apply retroactively to loaded images.
    Already existing objects retain their current scaling filters
]]
    love.graphics.setDefaultFilter('nearest', 'nearest')
                
    -- setNewFont() combines creating/setting a new font only works with TTF fonts
    -- FONT = love.graphics.setNewFont(FONT_PRESSSTART, 30)
    FONT = love.graphics.newFont(FONT_PRESSSTART, 8)
    love.graphics.setFont(FONT)

    titleWidth = FONT:getWidth(TITLE)
    titleHeight = FONT:getHeight(TITLE)
    
    -- Initialize the virtual resolution which will be rendered within the actual window
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
    
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    -- Apply the virtual resolution
    push:apply('start')

    -- Clear the screen to a specified color
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)
    -- To change font color, add a table as a first argument like this {{r, g, b, a}, string1, {r, g, b, a}, string2, ...}
    love.graphics.printf(TITLE, 0 , titleHeight, VIRTUAL_WIDTH, 'center')

    love.graphics.rectangle('fill', 10, 30, recWidth, recHeight)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - (10 +recWidth), VIRTUAL_HEIGHT - (30 + recHeight), recWidth, recHeight)
    
    push:apply('end')
end
