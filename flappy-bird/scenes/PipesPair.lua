Object = require './libs.classic'
PipesPair = Object:extend()

-- Size of the gap between pipes
local GAP_HEIGHT = 90

-- Create a new instance of the PipesPair class
function PipesPair:new(y)
    -- Initialize each pair of pipes outside of the right side of the screen
    self.x = VIRTUAL_WIDTH + 32

    -- y is for the topmost pipe
    self.y = y
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    -- Is this pipes pair ready to be removed from the scene
    self.remove = false
end

function PipesPair:update(dt)
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['upper'].x = self.x
        self.pipes['lower'].x = self.x
    else
        self.remove = true
    end
end

function PipesPair:render()
    for key, pipe in pairs(self.pipes) do
        pipe:render()
    end
end