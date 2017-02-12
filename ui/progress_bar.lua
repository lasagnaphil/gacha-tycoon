local Frame = require "ui.Frame"
local ProgressBar = class("ProgressBar", Frame)
local MText = require "ui.text_mixin"
ProgressBar:include(MText)

function ProgressBar:initialize(posX, posY, pivotX, pivotY, width, height, parent)
    Frame.initialize(self, posX, posY, pivotX, pivotY, width, height, parent)

    self:setProgress(0.5)
    self:setColors()
    self:setBorderWidth(1)
end

function ProgressBar:setProgress(progress)
    self.progress = progress
    return self
end

function ProgressBar:setBorderWidth(width)
    self.borderWidth = width
end
function ProgressBar:setColors(borderColor, innerColor, fillColor)
    self.borderColor = borderColor or {255, 0, 0, 255}
    self.innerColor = innerColor or {255, 255, 255, 255}
    self.fillColor = fillColor or {255, 0, 0, 255}
end

function ProgressBar:draw()
    love.graphics.setColor(unpack(self.innerColor))
    love.graphics.rectangle("fill", self.absX, self.absY, self.width, self.height)

    love.graphics.setColor(unpack(self.fillColor))
    love.graphics.rectangle("fill", self.absX, self.absY, self.width * self.progress, self.height)

    love.graphics.setColor(unpack(self.borderColor))
    love.graphics.setLineWidth(self.borderWidth)
    love.graphics.rectangle("line", self.absX, self.absY, self.width, self.height)

    love.graphics.setFont(self.font)
    love.graphics.setColor(unpack(self.fontColor))
    love.graphics.printf(self.text, self.absX, self.absY - self.height * 1.5, self.width, "center")

    love.graphics.setColor(255, 255, 255, 255)
end


return ProgressBar
