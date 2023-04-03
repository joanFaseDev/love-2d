--[[ 
    if the module passed is a lua file then .lua shouldn't be used
    use period to separate folders instead of forward slashes (work but only accidently)
]]
push = require 'libraries.push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

TITLE = "Pong"
FONT_AUDIOWIDE = 'assets/fonts/Audiowide-Regular.ttf'
FONT_PRESSSTART = 'assets/fonts/PressStart2P-Regular.ttf'

-- setNewFont() combines creating/setting a new font only works with TTF fonts
-- FONT = love.graphics.setNewFont(FONT_PRESSSTART, 30)
FONT = love.graphics.newFont(FONT_PRESSSTART, 30)
TITLE_WIDTH = FONT:getWidth(TITLE)
TITLE_HEIGHT = FONT:getHeight(TITLE)

--[[
    Runs when the game first starts up, only once; used to initialize the game
]]
function love.load()
    --[[ 
        This function does not apply retroactively to loaded images.
        Already existing objects retain their current scaling filters
    ]]
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Initialize the virtual resolution which will be rendered within the actual window
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
    
    love.graphics.setFont(FONT)
end

function love.draw()
    -- Apply the virtual resolution
    push:apply('start')
    love.graphics.printf(TITLE, 0, VIRTUAL_HEIGHT / 2 - TITLE_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
    push:apply('end')
end
