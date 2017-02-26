local class = require "lib.middleclass"
local Frame = class("Frame")
local BindVar = require "ui.mixins.bind_var"
Frame:include(BindVar)

function Frame:initialize(posX, posY, pivotX, pivotY, width, height, parent)
    self.posX = posX or 0
    self.posY = posY or 0
    self.pivotX = pivotX or 0.5
    self.pivotY = pivotY or 0.5
    self.width = width or 100
    self.height = height or 100
    self.parent = parent or nil
    self.absX, self.absY = self:getAbsolutePos()
    self.anchor = {
        minX = 0, maxX = 0,
        minY = 0, maxY = 0
    }
    self.children = {}
    self.isEnabled = true
    self.interactive = false
    lui:addFrame(self)
    BindVar.initialize(self)
end

function Frame:setEnable(value)
    self.isEnabled = value
    return self
end

function Frame:setEnableIncludingChildren(value)
    self.isEnabled = value
    for _, child in ipairs(self.children) do
       child:setEnable(value)
    end
    return self
end

function Frame:setParent(parent)
    parent.children[#parent.children + 1] = self
    self.parent = parent
    self:updatePos()
    return self
end

function Frame:setPos(x, y)
    self.posX, self.posY = x, y
    self:updatePos()
    return self
end

function Frame:setPivot(x, y)
    self.pivotX, self.pivotY = x, y
    self:updatePos()
    return self
end

function Frame:setSize(w, h)
    self.width, self.height = w, h
    self:updatePos()
    return self
end

function Frame:updatePos()
    self.absX = (self.parent and self.parent.absX or 0) + self.posX - self.pivotX * self.width
    self.absY = (self.parent and self.parent.absY or 0) + self.posY - self.pivotY * self.height
    for _, child in ipairs(self.children) do
        child:updatePos()
    end
end

function Frame:update(dt)
    self:updateBindings()
end

function Frame:draw()
    -- overload this function
end

function Frame:getAbsolutePos()
    if self.parent == nil then
        return self.posX - self.pivotX * self.width, self.posY - self.pivotY * self.height
    end
    return absX, absY
end

function Frame:drawDebug()
    love.graphics.circle('fill', self.absX + self.pivotX * self.width, self.absY + self.pivotY * self.height, 2)
    love.graphics.rectangle('line', self.absX, self.absY, self.width, self.height)
    for _, child in ipairs(self.children) do
        child:drawDebug()
    end
end

--
-- static variables
--

-- The root frame
Frame.static.root = {width = love.graphics.getWidth(), height = love.graphics.getHeight()}

function Frame.static.setRootSize(width, height)
    Frame.static.root.width = width
    Frame.static.root.height = height
end

return Frame
