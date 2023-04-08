Object = require('libraries.classic')
Paddle = Object:extend()

PLAYER_WIDTH = 5
PLAYER_HEIGHT = 20
PLAYER_SPEED = 5
PLAYER_MODE = 'fill'

function Paddle:new(x, y)
    self.x = x
    self.y = y
    self.width = PLAYER_WIDTH
    self.height = PLAYER_HEIGHT
    self.speed = PLAYER_SPEED
    self.mode = PLAYER_MODE
end

function Paddle:draw()
    love.graphics.rectangle(self.mode, self.x, self.y, self.width, self.height)
end