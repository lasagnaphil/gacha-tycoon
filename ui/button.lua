local class = require "lib.middleclass"

local Panel = require "ui.Panel"
local Button = class("Button", Panel)

function Button:initialize(posX, posY, pivotX, pivotY, width, height, spritePatches, text, font)
    if type(spritePatches) ~= "table" then
        error("Field spritePatches should be a table!")
    end
    Panel.initialize(self, posX, posY, pivotX, pivotY, width, height, spritePatches.normal, text, font)
    lui:addInteractiveFrame(self)
    --[[
        spritePatch = { normal = <patch>, pressed = <patch> }
    ]]
    self.spritePatches = spritePatches

    local cx, cy, cw, ch = self.sprite:get_content_box(self.absX, self.absY, self.width, self.height)
    self.contentX = cx
    self.contentY = cy
    self.contentWidth = cw
    self.contentHeight = ch

    self.interactive = true
    self.onPress = function() end
    self.onRelease = function() end
end

function Button:onPress(onPress)
    self.onPress = onPress
    return self
end

function Button:onRelease(onRelease)
    self.onRelease = onRelease
    return self
end

function Button:onPressInternal(x, y, button)
    local isPointerIn = self.absX < x and x < self.absX + self.width and
                        self.absY < y and y < self.absY + self.height
    print("" .. x .. " " .. y)
    if isPointerIn then
        self.sprite = self.spritePatches.pressed
        self.onPress()
    end
end
function Button:onReleaseInternal(x, y, button)
    local isPointerIn = self.absX < x and x < self.absX + self.width and
                        self.absY < y and y < self.absY + self.height
    if isPointerIn then
        print("World")
        self.sprite = self.spritePatches.normal
        self.onRelease()
    end
end

return Button
