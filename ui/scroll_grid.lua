local Panel = require "ui.panel"
local ScrollGrid = class("ScrollGrid", Panel)
local MInteractive = require "ui.mixins.interactive"
local MScrollable = require "ui.mixins.scrollable"

ScrollGrid:include(MInteractive)
ScrollGrid:include(MScrollable)

function ScrollGrid:initialize(posX, posY, pivotX, pivotY, width, height, spritePatch)
    Panel.initialize(self, posX, posY, pivotX, pivotY, width, height, spritePatch)
    MInteractive.initialize(self)
    MScrollable.initialize(self)

    self.entries = {}
    self.entryWidth = 20
    self.entryHeight = 20
    self.columns = 3
    self.rows = 4
    self.scrollPos = 0
    self.padding = 3

end

function ScrollGrid:setDimensions(columns, rows)
    self.columns = columns
    self.rows = rows
    return self
end

function ScrollGrid:setEntrySize(width, height)
    self.entryWidth = width
    self.entryHeight = height
    return self
end

function ScrollGrid:addEntry(entry)
    local x = #self.entries % self.columns
    local y = math.floor(#self.entries / self.columns)
    entry:setPos(x * (self.entryWidth + self.padding) + self.padding, y * (self.entryHeight + self.padding) + self.padding)
         :setPivot(0, 0)
         :setSize(self.entryWidth, self.entryHeight)

    self.entries[#self.entries + 1] = entry

    entry:setParent(self)

    return self
end

function ScrollGrid:addDefaultEntry(spritePatch, text, font, fontColor)
    local x = #self.entries % self.columns
    local y = math.floor(#self.entries / self.columns)
    local entry = Panel:new(x * self.entryWidth + self.padding, y * self.entryHeight + self.padding,
                            0, 0,
                            self.entryWidth, self.entryHeight,
                            spritePatch)
                       :setText(text)
                       :setFont(font, fontColor)

    self.entries[#self.entries + 1] = entry

    entry:setParent(self)

    return self
end

function ScrollGrid:clear()
    for _, entry in ipairs(self.entries) do
        lui:deleteFrame(entry)
    end
    for i = #self.children, 1, -1 do
        if self.children[i].isEntry == nil then
            table.remove(self.children, i)
        end
    end

    self.entries = {}
end

function ScrollGrid:getLeftoverSpace()
    return math.floor(#self.entries / self.columns) * (self.entryHeight + self.padding) - self.height
end

function ScrollGrid:updateEntryPos()
    for i, entry in ipairs(self.entries) do
        local w = (i - 1) % self.columns
        local h = math.floor((i - 1)/self.columns)
        entry:setPos(self.padding + w * (self.entryWidth + self.padding), -self.scrollPos + h * (self.entryHeight + self.padding))
    end
end

return ScrollGrid
