local class = require "lib.middleclass"
local Frame = require "ui.frame"
local MText = require "ui.mixins.text"

local Panel = class("Panel", Frame)
Panel:include(MText)

function Panel:initialize(posX, posY, pivotX, pivotY, width, height, spritePatch)
    Frame.initialize(self, posX, posY, pivotX, pivotY, width, height)
    if spritePatch ~= nil then
        if spritePatch.get_content_box then
            self:setSpritePatch(spritePatch)
        else
            self:setSprite(spritePatch)
        end
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
    self.isNinePatch = false
end

function Panel:setSprite(sprite)
    self.isNinePatch = false
    self.sprite = sprite
    self:updateSpritePos()

    return self
end

function Panel:setSpritePatch(spritePatch)
    self.isNinePatch = true
    self.sprite = spritePatch
    self.spritePatch = spritePatch
    self:updateSpritePos()

    return self
end

function Panel:updateSpritePos()
    if self.isNinePatch then
        local cx, cy, cw, ch = self.spritePatch:get_content_box(self.absX, self.absY, self.width, self.height)
        self.contentX = cx
        self.contentY = cy
        self.contentWidth = cw
        self.contentHeight = ch
    else
        self.contentX = self.absX
        self.contentY = self.absY
        self.contentWidth = self.width
        self.contentHeight = self.height
    end
end

function Panel:draw()
    local cx, cy, cw, ch
    if self.sprite then
        cx, cy, cw, ch = self.sprite:draw(self.absX, self.absY, self.width, self.height)
    else
        cx, cy, cw, ch = self.absX, self.absY, self.width, self.height
    end
    self.contentX = cx
    self.contentY = cy
    self.contentWidth = cw
    self.contentHeight = ch
    if self.text and self.text ~= "" then
        self:drawText(cx, cy, cw, ch)
    end
end

function Panel:drawText(cx, cy, cw, ch)
    love.graphics.setFont(self.font)
    local fontHeight = self.font:getHeight()
    love.graphics.setColor(unpack(self.fontColor))
    love.graphics.printf(self.text, cx, cy + ch/2 - fontHeight/2, cw, self.align)
    love.graphics.setColor(255, 255, 255, 255)
end

return Panel
