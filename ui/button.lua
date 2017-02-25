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

    MInteractive.initialize(self)
end

function Button:setSpritePatches(spritePatches)
    self.spritePatches = spritePatches
    return self
end

function Button:onPressInternal(x, y, button)
    MInteractive.onPressInternal(self, x, y, button)
    self.sprite = self.isPressed and self.spritePatches.pressed or self.spritePatches.normal
end

function Button:onReleaseInternal(x, y, button)
    MInteractive.onReleaseInternal(self, x, y, button)
    self.sprite = self.isPressed and self.spritePatches.pressed or self.spritePatches.normal
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
