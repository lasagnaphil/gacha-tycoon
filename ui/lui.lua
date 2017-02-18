local class = require "lib.middleclass"

lui = {}

lui.Frame = require "ui.frame"
lui.Panel = require "ui.panel"
lui.Button = require "ui.button"
lui.ProgressBar = require "ui.progress_bar"
lui.ScrollList = require "ui.scroll_list"

-- all the frames
lui.frames = {}
-- interactive frames
lui.iframes = {}

function lui:init(CScreenInfo)
    self.screenInfo = CScreenInfo
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

function recursiveDraw(frame)
    frame:draw()
    for _, child in ipairs(frame.children) do
        recursiveDraw(child)
    end
end
function lui:draw()
    for _, frame in ipairs(self.frames) do
        if frame.parent == nil and frame.isEnabled then
            recursiveDraw(frame)
        end
    end
end

function lui:update(dt)
    if love.mouse.isDown(1) then
        local tx, ty, fsv = unpack(self.screenInfo)
        local x, y = love.mouse.getX(), love.mouse.getY()
        for _, frame in ipairs(self.iframes) do
            if frame.isEnabled then
                frame:whilePressInternal(x/fsv - tx, y/fsv - ty, 1)
            end
        end
    end
    for _, frame in ipairs(self.frames) do
        frame:update(dt)
    end
end

function lui:pressed(x, y, button)
    for _, frame in ipairs(self.iframes) do
        if frame.isEnabled then
            frame:onPressInternal(x, y, button)
        end
    end
end

function lui:released(x, y, button)
    for _, frame in ipairs(self.iframes) do
        if frame.isEnabled then
            frame:onReleaseInternal(x, y, button)
        end
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
