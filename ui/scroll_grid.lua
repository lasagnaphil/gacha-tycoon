local Panel = require "ui.panel"
local ScrollGrid = class("ScrollGrid", Panel)
local MInteractive = require "ui.mixins.interactive"
ScrollGrid:include(MInteractive)

function ScrollGrid:initialize(posX, posY, pivotX, pivotY, width, height, spritePatch)
    Panel.initialize(self, posX, posY, pivotX, pivotY, width, height, spritePatch)
    MInteractive.initialize(self)

    self.entries = {}
    self.entryWidth = 20
    self.entryHeight = 20
    self.columns = 6
    self.rows = 4
    self.scrollPos = 0
    self.padding = 3
    self.lastClickPos = nil

end

function ScrollGrid:setEntrySize(width, height)
    self.entryWidth = width
    self.entryHeight = height
    return self
end

function ScrollGrid:addDefaultEntry(spritePatch, text, font, fontColor)
    local x = #self.entries % self.columns
    local y = #self.entries / self.columns
    local entry = Panel:new(self.padding + x * self.entryWidth, self.padding + y * self.entryHeight,
                            0, 0,
                            self.entryWidth - self.padding, self.entryHeight - self.padding)

    self.entries[#self.entries + 1] = entry

    entry:setParent(self)

    return self
end

function ScrollGrid:updateEntryPos()
    for i, entry in ipairs(self.entries) do
        local h = i % self.columns
        entry:setPos(entry.posX, entry.posY + self.scrollPos + (h-1) * self.entryHeight)
    end
end

return ScrollGrid
