local Panel = require "ui.panel"

local scrollable = {
    initialize = function(self)
        self.scrollPos = 0
        self.deltaScroll = 0
        self.scrollFriction = 1
    end,
    onPressInternal = function(self, x, y, button)
        if self:isPointerInBounds(x, y) then
            self.lastClickPos = y
            return true
        end
        return false
    end,
    onReleaseInternal = function(self, x, y, button)
        self.lastClickPos = nil
        --self:afterScroll()
    end,
    whilePressInternal = function(self, x, y, button)
        if self.lastClickPos then
            local deltaY = y - self.lastClickPos
            self:scroll(deltaY)
            self.lastClickPos = y
        end
    end,
    getLeftoverSpace = function(self)
        override_error("Scrollable", "getLeftoverSpace")
    end,
    scroll = function(self, height)
        self.deltaScroll = height
        local numEntries = #self.entries
        local leftoverSpace = self:getLeftoverSpace()
        self.scrollPos = self.scrollPos - height
        if self.scrollPos < -self.padding then
            self.scrollPos = -self.padding
        else
            if leftoverSpace < 0 then self.scrollPos = -self.padding
            elseif self.scrollPos > leftoverSpace + self.padding then
                self.scrollPos = leftoverSpace + self.padding
            end
        end
        self:updateEntryPos()
    end,
    afterScroll = function(self)
        local threshold = 1
        if self.deltaScroll > threshold then
            self:scroll(self.deltaScroll - self.scrollFriction)
        elseif self.deltaScroll < - threshold then
            self:scroll(self.deltaScroll + self.scrollFriction)
        else
            self.deltaScroll = 0
        end
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
