Object = require './libs.classic'
Bird = Object:extend()

local GRAVITY = 12

-- Create a new instance of the Bird class
function Bird:new()
    self.image = love.graphics.newImage('assets/images/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- Initialize the bird position to the middle of the screen
    self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    self.y = VIRTUAL_HEIGHT / 2 - self.height / 2

    -- Initialize the bird's vertical velocity (delta Y) to 0
    self.dY = 0
end

-- Render the instance in the middle of the screen
function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:update(dt)
    -- Increase the Y velocity (delta Y) every frame to mimic true gravity
    self.dY = self.dY + GRAVITY * dt

    -- Velocity still need to be applied to the bird's y position for any change to be visible
    self.y = self.y + self.dY

    if love.keyboard.wasPressed('space') then
        self.dY = -3
    end
end