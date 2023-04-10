Object = require('libraries.classic')
Paddle = Object:extend()

PLAYER_WIDTH = 5
PLAYER_HEIGHT = 20
PLAYER_DELTA_Y = 200
PLAYER_MODE = 'fill'
PLAYER_SCORE = 8

-- Create a new instance of player
function Paddle:new(x, y, keyUp, keyDown)
    self.x = x
    self.y = y
    self.width = PLAYER_WIDTH
    self.height = PLAYER_HEIGHT
    self.deltaY = PLAYER_DELTA_Y
    self.mode = PLAYER_MODE
    self.keyUp = keyUp
    self.keyDown = keyDown
    self.score = PLAYER_SCORE
end

-- Player can move vertically but cannot go beyond game screen
function Paddle:move(dt)
    if love.keyboard.isDown(self.keyUp) then
        self.y = self.y - self.deltaY * dt
    elseif love.keyboard.isDown(self.keyDown) then
        self.y = self.y + self.deltaY * dt
    end

    if self.y < 0 then
        self.y = 0
    end

    if self.y > GAME_HEIGHT - self.height then
        self.y = GAME_HEIGHT - self.height
    end
end

-- Check for collision using AABB's algorithm
function Paddle:collide(ball)
    if self.x + self.width > ball.x and
        self.x < ball.x + ball.width and
        self.y + self.height > ball.y and
        self.y < ball.y + ball.height then
        return true
    else
        return false
    end
end

-- Reinitialize the player's position 
function Paddle:reset()
    -- Player 1
    if self.x == 0 then
        self.y = GAME_HEIGHT - self.height
    end

    -- Player 2
    if self.x == GAME_WIDTH - self.width then
        self.y = 0
    end
end

-- Render player instance
function Paddle:draw()
    love.graphics.rectangle(self.mode, self.x, self.y, self.width, self.height)
end