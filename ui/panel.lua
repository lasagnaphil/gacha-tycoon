local class = require "lib.middleclass"
local Frame = require "ui.frame"
local MText = require "ui.text_mixin"

local Panel = class("Panel", Frame)
Panel:include(MText)

function Panel:initialize(posX, posY, pivotX, pivotY, width, height, spritePatch)
    Frame.initialize(self, posX, posY, pivotX, pivotY, width, height)
    self.sprite = spritePatch

    local cx, cy, cw, ch = spritePatch:get_content_box(self.absX, self.absY, self.width, self.height)
    self.contentX = cx
    self.contentY = cy
    self.contentWidth = cw
    self.contentHeight = ch

    self.text = text or ""
    self.font = font
    self.fontColor = {255, 255, 255, 255}
end

function Panel:draw()
    local cx, cy, cw, ch = self.sprite:draw(self.absX, self.absY, self.width, self.height)
    self.contentX = cx
    self.contentY = cy
    self.contentWidth = cw
    self.contentHeight = ch
    if self.text ~= "" then
        love.graphics.setFont(self.font)
        local fontHeight = self.font:getHeight()
        love.graphics.setColor(unpack(self.fontColor))
        love.graphics.printf(self.text, cx, cy + ch/2 - fontHeight/2, cw, "center")
        love.graphics.setColor(255, 255, 255, 255)
    end
end

return Panel
