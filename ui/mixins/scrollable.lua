local Panel = require "ui.panel"

local scrollable = {
    scroll = function(self, height)
        override_error("Scrollable", "scroll")
    end,
    onPressInternal = function(self, x, y, button)
    end,
    onReleaseInternal = function(self, x, y, button)
        self.lastClickPos = nil
    end,
    whilePressInternal = function(self, x, y, button)
        if self:isPointerInBounds(x, y) then
            if self.lastClickPos ~= nil then
                local deltaY = y - self.lastClickPos
                self:scroll(deltaY)
            end
            self.lastClickPos = y
        end
    end,
    scroll = function(self, height)
        local numEntries = #self.entries
        local leftoverSpace = numEntries * self.entryHeight - self.height
        self.scrollPos = self.scrollPos - height
        if self.scrollPos < -self.padding then
            self.scrollPos = -self.padding
        else
            if leftoverSpace < 0 then self.scrollPos = 0
            elseif self.scrollPos > leftoverSpace then
                self.scrollPos = leftoverSpace
            end
        end
        self:updateEntryPos()
    end,
    updateEntryPos = function(self)
        override_error("Scrollable", "updateEntryPos")
    end,
    draw = function(self)
        Panel.draw(self)
        local screenInfo = CScreen.getInfo()
        self.scissor = {(screenInfo.tx + self.absX + self.padding) * screenInfo.fsv, (screenInfo.ty + self.absY + self.padding) * screenInfo.fsv,
                        (self.width - self.padding * 2) * screenInfo.fsv, (self.height - self.padding * 2) * screenInfo.fsv}
    end
}
return scrollable
