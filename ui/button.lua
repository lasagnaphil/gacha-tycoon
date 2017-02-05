local class = require "lib.middleclass"

local Frame = require "ui.frame"
local Button = class("Button", Frame)

function Button:initialize(posX, posY, pivotX, pivotY, width, height, spritePatches, text, font)
    Frame.initialize(self, posX, posY, pivotX, pivotY, width, height)
    --[[
        spritePatch = { normal = <patch>, pressed = <patch> }
    ]]
    if type(spritePatches) ~= "table" then
        error("Field spritePatches should be a table!")
    end
    self.spritePatches = spritePatches
    self.sprite = spritePatches.normal

    local cx, cy, cw, ch = self.sprite:get_content_box(self.absX, self.absY, self.width, self.height)
    self.contentX = cx
    self.contentY = cy
    self.contentWidth = cw
    self.contentHeight = ch

    self.text = text or ""
    self.font = font

    self.interactive = true
    self.onPress = function() end
    self.onRelease = function() end
end

function Button:setText(text)
    self.text = text
    return self
end
function Button:setFont(font)
    self.font = font
    return self
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

function Button:draw()
    local cx, cy, cw, ch = self.sprite:draw(self.absX, self.absY, self.width, self.height)
    self.contentX = cx
    self.contentY = cy
    self.contentWidth = cw
    self.contentHeight = ch
    love.graphics.setFont(self.font)
    local fontHeight = self.font:getHeight()
    love.graphics.printf(self.text, cx, cy + ch/2 - fontHeight/2, cw, "center")
end

return Button
