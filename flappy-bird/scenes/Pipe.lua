Object = require './libs.classic'
Pipe = Object:extend()

--[[ 
    All pipes look the same so there's no reason to create a new image every time a pipe is instanciated.
    The most efficient way is to instanciate one image only and to use it to render all pipes.
]]
local PIPE_IMAGE = love.graphics.newImage('assets/images/pipe.png')
PIPE_SPEED = 60

-- True size of the pipe image
PIPE_WIDTH = 70
PIPE_HEIGHT = 288 

-- New pipes are instantiated just outside of the screen's right side with random heights.
function Pipe:new(orientation, y)
    self.x = VIRTUAL_WIDTH
    -- min and max are both inclusive
    self.y = y

    self.width = PIPE_IMAGE:getWidth()
    self.heigth = PIPE_HEIGHT
    self.orientation = orientation
end


function Pipe:update(dt)
end

-- Render the instance just outside of screen
function Pipe:render()
    love.graphics.draw(
        PIPE_IMAGE, self.x,
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),
        0, 
        1, 
        self.orientation == 'top' and -1 or 1
    )
end