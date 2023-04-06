Object = require 'libraries.classic'

--[[
    Represents a ball, bouncing back and forth between paddles
]]

Ball = Object:extend()

function Ball:new(x, y)
    self.x = x
    self.y = y
    self.width = 4
    self.height = 4
    self.dX = math.random(2) == 1 and 100 or -100
    self.dY = math.random(-50, 50)
end

-- Reinitialize a ball's position and velocity
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    self.y = VIRTUAL_HEIGHT / 2 - self.height / 2
    self.dX = math.random(2) == 1 and 100 or -100
    self.dY = math.random(-50, 50)
end

-- Use the AABB (Axis Aligned Bounding Box) algorithms to check if there is collision between the ball and one of the paddle
function Ball:collision(paddle)
    -- Check if either of the left edge of the ball / paddle is farther than the left edge of the paddle / ball
    if self.x > paddle.x + paddle.width or
        paddle.x > self.x + self.width then
            return false;
    end

    -- Check if the top edge of the ball / paddle is further than the top edge of the paddle / ball
    if self.y > paddle.y + paddle.height or
        paddle.y > self.y + self.height then
            return false;
    end
    
    -- If none of the above is true then there is collision
    return true;
end

-- Update a ball's position with its velocity multiply by delta time
function Ball:update(dt)
    self.x = self.x + self.dX * dt
    self.y = self.y + self.dY * dt
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end