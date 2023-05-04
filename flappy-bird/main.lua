push = require '/libs.push' 

require './scenes.Bird'
require './scenes.Pipe'
require './scenes.PipesPair'

WINDOW_WIDTH = 1280
WINDOW_HEIGTH = 720

-- 16 by 9 for 32 pixels sprite
VIRTUAL_WIDTH = 512 -- 32 * 16 = 512
VIRTUAL_HEIGHT = 288 -- 32 * 9 = 288

-- Local variables cannot be accessed in other files
local background = love.graphics.newImage('assets/images/background.png') -- 1157 * 288
local ground = love.graphics.newImage('assets/images/ground.png')

-- Position X of each image
local backgroundScrollX = 0
local groundScrollX = 0

-- Scrolling speed of each image
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local spawnTimer = 0

--[[ 
    413 isn't an arbitrary value, it's the exact point where the pattern of the image's far left side starts again therefore forming an uninterrupted loop.
]]
local BACKGROUND_LOOPING_POINT = 413

local bird = Bird()
local pipes = {}
local pipesPair = {}

--[[ 
    Keep the y position of the last recorded pipesPair instance. Used to make sure the gap between the pipesPair
    instances transition nicely and is actually beatable by the player.
]]
local lastPipesPairY = -PIPE_HEIGHT + math.random(80) + 20

-- Scrolling variable to pause the game when we collide with a pipe.
local scrolling = true

-- Is called at the beginning of the love's program execution
function love.load()
    -- Apply nearest default filtering on upscale and downscale which means crisp pixel art and less bluriness
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Flappy Bird')

    -- Initialize push by giving it the game's fixed resolution and the resolution of the window the game needs to adapt
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGTH, { 
        vsync = true,
        fullscreen = false, 
        resizable = true  
    })

    -- Very simple way to prevent having the same seed twice in a row.
    math.randomseed(os.time())

    -- Declare a new love.keyboard property and initialize it with an empty table
    love.keyboard.keyPressed = {}
end

function love.update(dt)
    if scrolling then
        --[[
            Once the scrolling X values reach their looping point value the modulo operator will return 0 therefore reinitializing the scrolling X values and creating a perfect loop for the background/ground
        ]]
        backgroundScrollX = (backgroundScrollX + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        groundScrollX = (groundScrollX + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
        bird:update(dt)
        spawnTimer = spawnTimer + dt
        -- Every 2 seconds, add a Pipe instance to the table and reset the countdown
        if spawnTimer > 2 then
            --[[
                Modify slightly the last Y coordinate we placed so pipe gaps aren't too
                far apart.
                No higher than 10 pixels below the top edge of the screen and no lower than
                a gap length (local gap height is 90 pixels cf. PipesPair.lua) from the bottom
            ]]
            local y = math.max(
                -PIPE_HEIGHT + 10,
                math.min(
                    lastPipesPairY + math.random(-20, 20),
                    VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT
                )
            )
            lastPipesPairY = y
            table.insert(pipesPair, PipesPair(y))
            spawnTimer = 0
        end
        --[[
            Make all the pipes move towards the left side of the screen.
            If a pipe leaves the screen that way, remove it from the table.
        ]]
        for key, pair in pairs(pipesPair) do
            pair:update(dt)

            -- If bird is colliding with pipes then...
            for l, pipe in pairs(pair.pipes) do
                if bird:collides(pipe) then
                    -- ...pause the game
                    scrolling = false
                end
            end
        end

        for key, pair in pairs(pipesPair) do
            if pair.remove then
                table.remove(pipesPair, key)
            end
        end
    end

    --[[ 
        Reset the keyPressed table every frame but only after love2d checked for any input
        All inputs / system events are processed at the beginning of every frame, before love.update is executed
    ]]
    love.keyboard.keyPressed = {}
end

function love.draw()
    push:start()

    --[[ 
        Background and ground's x axe is negative so to be directed in the opposite direction of the player therefore creating the illusion of movement
    ]]
    love.graphics.draw(background, -backgroundScrollX, 0)

    -- Pipes are rendered between the background and the ground (the latter hides the bottom of each pipe) 
    for key, pair in pairs(pipesPair) do
        pair:render()
    end

    love.graphics.draw(ground, -groundScrollX, VIRTUAL_HEIGHT - ground:getHeight())

    bird:render()

    push:finish()
end

function love.resize(w, h)
    push:resize(w, h)
end

--[[ 
    Callback function triggered every time a key is pressed
    Beware that declaring a love.keypressed() function in another class would overwrite this implementation
]]
function love.keypressed(key)
    love.keyboard.keyPressed[key] = true

    -- Press Escape to quit the game
    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keyPressed[key] then
        return true
    else
        return false
    end
end
