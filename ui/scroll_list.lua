local Panel = require "ui.Panel"
local ScrollList = class("ScrollList", Panel)
ScrollList:include()

function ScrollList:initialize(posX, posY, pivotX, pivotY, width, height, spritePatch)
    Panel.initialize(self, posX, posY, pivotX, pivotY, width, height, spritePatch)
    self.entries = {}
    self.entryHeight = 20
    self.entryScrollPos = 0
    self.padding = 3
end

function ScrollList:addEntry(entry)
    if not entry.isInstanceOf or not entry:isInstanceOf(Frame) then
        error("Added invalid entry for scroll list")
    end
    return self
end

function ScrollList:addDefaultEntry(spritePatch, text, font, fontColor)
    local entry = Panel:new(self.absX + self.padding, self.absY + #self.entries * self.entryHeight + self.padding,
                            0, 0,
                            self.width - self.padding * 2, self.entryHeight - self.padding,
                            spritePatch)
        :setText(text)
        :setFont(font, fontColor)

    self.entries[#self.entries + 1] = entry

    return self
end

function ScrollList:scroll(height)
    for _, entry in ipairs(self.entries) do
        self.entries = self.entries + height
    end
end

function ScrollList:draw()
    Panel.draw(self)
    for _, entry in ipairs(self.entries) do
        entry:draw()
    end
end
return ScrollList
