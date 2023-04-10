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

-- Calculate ball's movement by adding velocity to its last position
function Ball:move(dt)
    ball.x = ball.x + ball.deltaX * dt
    ball.y = ball.y + ball.deltaY * dt
end

-- Prevent the ball to exit the screen through top/down sides
function Ball:collide()
    -- There is no need to change horizontal velocity here
    -- Also the ball only gains speed when a player send it back
    if ball.y <= 0 then
        sounds['out-of-bonds']:play()
        ball.y = 0
        ball.deltaY = -ball.deltaY
    end

    if ball.y >= GAME_HEIGHT - ball.height then
        sounds['out-of-bonds']:play()
        ball.y = GAME_HEIGHT - ball.height
        ball.deltaY = -ball.deltaY
    end
end

-- Reinitialize the ball's position
function Ball:reset()
    ball.x = GAME_WIDTH / 2 - ball.width / 2
    ball.y = GAME_HEIGHT / 2 - ball.height / 2
end

-- Render ball instance
function Ball:draw()
    love.graphics.rectangle(self.mode, self.x, self.y, self.width, self.height)
end