local class = require "lib.middleclass"

local Panel = require "ui.panel"
local MInteractive = require "ui.mixins.interactive"

local Button = class("Button", Panel)
Button:include(MInteractive)

function Button:initialize(posX, posY, pivotX, pivotY, width, height, spritePatches, text, font)
    if type(spritePatches) ~= "table" then
        error("Field spritePatches should be a table!")
    end
    Panel.initialize(self, posX, posY, pivotX, pivotY, width, height, spritePatches.normal, text, font)
    --[[
        spritePatch = { normal = <patch>, pressed = <patch> }
    ]]
    self.spritePatches = spritePatches

    --[[
    local cx, cy, cw, ch = self.sprite:get_content_box(self.absX, self.absY, self.width, self.height)
    self.contentX = cx
    self.contentY = cy
    self.contentWidth = cw
    self.contentHeight = ch
    ]]

    MInteractive.initialize(self)
end

function Button:drawText(cx, cy, cw, ch)
    love.graphics.setFont(self.font)
    local fontHeight = self.font:getHeight()
    love.graphics.setColor(unpack(self.fontColor))
    if self.interactive and self.isPressed then
        love.graphics.printf(self.text, cx, cy + ch/2 - fontHeight/2 + 1, cw, self.align)
    else
        love.graphics.printf(self.text, cx, cy + ch/2 - fontHeight/2, cw, self.align)
    end
    love.graphics.setColor(255, 255, 255, 255)
end

return Button
