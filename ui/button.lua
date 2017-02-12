local class = require "lib.middleclass"

local Panel = require "ui.Panel"
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

    local cx, cy, cw, ch = self.sprite:get_content_box(self.absX, self.absY, self.width, self.height)
    self.contentX = cx
    self.contentY = cy
    self.contentWidth = cw
    self.contentHeight = ch

    self:interactiveInit()
end

return Button
