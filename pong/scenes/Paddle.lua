Object = require 'libraries.classic'

Paddle = Object:extend()

function Paddle:new(x, y)
    self.x = x
    self.y = y
    self.width = 5
    self.height = 20
    self.speed = 200
    self.dY = 0
end

function Paddle:reset(x, y)
    self.x = x
    self.y = y
end

function Paddle:update(dt)
    if self.dY < 0 then
        self.y = math.max(0, self.y + self.dY * dt )
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dY * dt)
    end
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end