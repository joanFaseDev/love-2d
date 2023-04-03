WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
TITLE = "Pong"
FONT_AUDIOWIDE = 'assets/fonts/Audiowide-Regular.ttf'
FONT_PRESSSTART = 'assets/fonts/PressStart2P-Regular.ttf'

-- setNewFont() combines creating/setting a new font only works with TTF fonts
FONT = love.graphics.setNewFont(FONT_PRESSSTART, 18)
TITLE_WIDTH = FONT:getWidth(TITLE)
TITLE_HEIGHT = FONT:getHeight(TITLE)

--[[
    Runs when the game first starts up, only once; used to initialize the game
]]
function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

function love.draw()
    love.graphics.printf(TITLE, 0, WINDOW_HEIGHT / 2 - TITLE_HEIGHT / 2, WINDOW_WIDTH, 'center')
end
