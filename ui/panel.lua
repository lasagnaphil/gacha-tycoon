local class = require "lib.middleclass"
local Frame = require "ui.frame"
local MText = require "ui.mixins.text"

local Panel = class("Panel", Frame)
Panel:include(MText)

function Panel:initialize(posX, posY, pivotX, pivotY, width, height, spritePatch)
    Frame.initialize(self, posX, posY, pivotX, pivotY, width, height)
    if spritePatch ~= nil then
        self.sprite = spritePatch

        local cx, cy, cw, ch = spritePatch:get_content_box(self.absX, self.absY, self.width, self.height)
        self.contentX = cx
        self.contentY = cy
        self.contentWidth = cw
        self.contentHeight = ch
    else
        self.contentX = absX
        self.contentY = absY
        self.contentWidth = width
        self.contentHeight = height
    end

    self.text = text or ""
    self.font = font
    self.fontColor = {255, 255, 255, 255}
    self.align = "center"
end

function Panel:setSpritePatch(spritePatch)
    self.sprite = spritePatch

    local cx, cy, cw, ch = spritePatch:get_content_box(self.absX, self.absY, self.width, self.height)
    self.contentX = cx
    self.contentY = cy
    self.contentWidth = cw
    self.contentHeight = ch

    return self
end

function Panel:draw()
    local cx, cy, cw, ch
    if self.sprite ~= nil then
        cx, cy, cw, ch = self.sprite:draw(self.absX, self.absY, self.width, self.height)
    else
        cx, cy, cw, ch = self.absX, self.absY, self.width, self.height
    end
    self.contentX = cx
    self.contentY = cy
    self.contentWidth = cw
    self.contentHeight = ch
    if self.text and self.text ~= "" then
        love.graphics.setFont(self.font)
        local fontHeight = self.font:getHeight()
        love.graphics.setColor(unpack(self.fontColor))
        love.graphics.printf(self.text, cx, cy + ch/2 - fontHeight/2, cw, self.align)
        love.graphics.setColor(255, 255, 255, 255)
    end
end

return Panel
