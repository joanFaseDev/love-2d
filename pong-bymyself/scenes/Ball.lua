Object = require('libraries.classic')

Ball = Object:extend()

BALL_WIDTH = 4
BALL_HEIGHT = 4
BALL_SPEED = 200
BALL_MODE = 'fill'

function Ball:new(x, y)
    self.x = x
    self.y = y
    self.width = BALL_WIDTH
    self.height = BALL_HEIGHT
    self.speed = BALL_SPEED
    self.mode = BALL_MODE
end

function Ball:draw()
    love.graphics.rectangle(self.mode, self.x, self.y, self.width, self.height)
end