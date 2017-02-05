local class = require "lib.middleclass"
local Frame = require "ui.frame"

local Panel = class("Panel", Frame)

function Panel:initialize(posX, posY, pivotX, pivotY, width, height, spritePatch)
    Frame.initialize(self, posX, posY, pivotX, pivotY, width, height)
    self.sprite = spritePatch

    local cx, cy, cw, ch = spritePatch:get_content_box(self.absX, self.absY, self.width, self.height)
    self.contentX = cx
    self.contentY = cy
    self.contentWidth = cw
    self.contentHeight = ch
end

function Panel:draw()
    local cx, cy, cw, ch = self.sprite:draw(self.absX, self.absY, self.width, self.height)
    self.contentX = cx
    self.contentY = cy
    self.contentWidth = cw
    self.contentHeight = ch
end

return Panel
