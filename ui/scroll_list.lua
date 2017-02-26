local Panel = require "ui.panel"
local ScrollList = class("ScrollList", Panel)
local MInteractive = require "ui.mixins.interactive"
local MScrollable = require "ui.mixins.scrollable"

ScrollList:include(MInteractive)
ScrollList:include(MScrollable)

function ScrollList:initialize(posX, posY, pivotX, pivotY, width, height, spritePatch)
    Panel.initialize(self, posX, posY, pivotX, pivotY, width, height, spritePatch)
    MInteractive.initialize(self)
    MScrollable.initialize(self)

    self.entries = {}
    self.entryHeight = 20
    self.scrollPos = 0
    self.padding = 3
end

function ScrollList:setEntryHeight(height)
    self.entryHeight = height
    return self
end

function ScrollList:addEntry(entry)
    --[[
    if not entry.isInstanceOf or not entry:isInstanceOf(Frame) then
        error("Added invalid entry for scroll list")
    end
    ]]
    entry:setPos(self.padding, #self.entries * self.entryHeight + self.padding)
         :setPivot(0, 0)
         :setSize(self.width - self.padding * 2, self.entryHeight - self.padding)

    self.entries[#self.entries + 1] = entry

    entry:setParent(self)

    return self
end

function ScrollList:addDefaultEntry(spritePatch, text, font, fontColor)
    local entry = Panel:new(self.padding, #self.entries * self.entryHeight + self.padding,
                            0, 0,
                            self.entryWidth, self.entryHeight,
                            spritePatch)
        :setText(text)
        :setFont(font, fontColor)

    entry.isEntry = true

    self.entries[#self.entries + 1] = entry

    entry:setParent(self)

    return self
end

function ScrollList:clear()
    for _, entry in ipairs(self.entries) do
        lui:deleteFrame(entry)
    end
    self.children = iter(self.children)
        :filter(function(child) return child.isEntry == nil end)
        :totable()

    self.entries = {}
end

function ScrollList:getLeftoverSpace()
    return #self.entries * self.entryHeight - self.height
end

function ScrollList:updateEntryPos()
    for i, entry in ipairs(self.entries) do
        entry:setPos(entry.posX, -self.scrollPos + (i-1) * self.entryHeight)
    end
end

return ScrollList
