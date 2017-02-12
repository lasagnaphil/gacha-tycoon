local class = require "lib.middleclass"

lui = {}

lui.Frame = require "ui.frame"
lui.Panel = require "ui.panel"
lui.Button = require "ui.button"
lui.ProgressBar = require "ui.progress_bar"

-- all the frames
lui.frames = {}
-- interactive frames
lui.iframes = {}

function lui:init()
end

function lui:addFrame(frame)
    self.frames[#self.frames + 1] = frame
end

function lui:addInteractiveFrame(frame)
    self.iframes[#self.iframes + 1] = frame
end

function lui:setRootSize(w, h)
    self.Frame.static.setRootSize(w, h)
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
    local frame = self.Frame:new(...)
    return frame
end

function lui:newPanel(...)
    local panel = self.Panel:new(...)
    return panel
end

function lui:newButton(...)
    local button = self.Button:new(...)
    return button
end

function lui:clear()
    lui.frames = {}
    lui.iframes = {}
end

return lui
