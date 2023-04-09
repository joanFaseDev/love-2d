Object = require('libraries.classic')

Ball = Object:extend()

BALL_WIDTH = 4
BALL_HEIGHT = 4
BALL_SPEED = 100
BALL_MODE = 'fill'

-- Create a ball instance
function Ball:new(x, y)
    self.x = x
    self.y = y
    self.deltaX = (math.random(2) == 1) and 100 or -100
    self.deltaY = math.random(-50, 50)
    self.width = BALL_WIDTH
    self.height = BALL_HEIGHT
    self.speed = BALL_SPEED
    self.mode = BALL_MODE
end

function Ball:move(dt)
    ball.x = ball.x + ball.deltaX * dt
    ball.y = ball.y + ball.deltaY * dt
end

-- Render ball instance
function Ball:draw()
    love.graphics.rectangle(self.mode, self.x, self.y, self.width, self.height)
end