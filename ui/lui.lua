local class = require "lib.middleclass"

lui = {}
local Frame = require "ui.frame"
local Panel = require "ui.panel"
local Button = require "ui.button"

-- all the frames
lui.frames = {}
-- interactive frames
lui.iframes = {}

function lui:init()
end

function lui:addFrame(frame)
    self.frames[#self.frames + 1] = frame
    if frame.interactive then
        self.iframes[#self.iframes + 1] = frame
    end
end

function lui:setRootSize(w, h)
    Frame.static.setRootSize(w, h)
end

function lui:draw()
    for _, frame in ipairs(self.frames) do
        frame:draw()
    end
end

function lui:pressed(x, y, button)
    for _, frame in ipairs(self.iframes) do
        frame:onPressInternal(x, y, button)
    end
end

function lui:released(x, y, button)
    for _, frame in ipairs(self.iframes) do
        frame:onReleaseInternal(x, y, button)
    end
end

function lui:newFrame(...)
    local frame = Frame:new(...)
    self:addFrame(frame)
    return frame
end

function lui:newPanel(...)
    local panel = Panel:new(...)
    self:addFrame(panel)
    return panel
end

function lui:newButton(...)
    local button = Button:new(...)
    self:addFrame(button)
    return button
end

function lui:clear()
    lui.frames = {}
    lui.iframes = {}
end

return lui
