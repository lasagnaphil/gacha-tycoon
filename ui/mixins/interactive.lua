local Interactive = {
    initialize = function(self)
        self.interactive = true
        self.isPressed = false
        self.toggleable = false
        self.onPressCallback = function() end
        self.onReleaseCallback = function() end
        lui:addInteractiveFrame(self)
    end,
    setToggleable = function(self, toggleable)
        self.toggleable = toggleable
        return self
    end,
    onPress = function(self, callback)
        self.onPressCallback = callback
        return self
    end,
    onRelease = function(self, callback)
        self.onReleaseCallback = callback
        return self
    end,
    isPointerInBounds = function(self, x, y)
        return self.absX < x and x < self.absX + self.width and
               self.absY < y and y < self.absY + self.height
    end,
    -- override those functions if necessary
    onPressInternal = function(self, x, y, button)
        if self:isPointerInBounds(x, y) then
            self.isPressed = true
            self.onPressCallback()
            return true
        end
        return false
    end,
    onReleaseInternal = function(self, x, y, button)
        if self.toggleable then
            if self:isPointerInBounds(x, y) then
                self.onReleaseCallback()
                self.isPressed = true
            else
                self.isPressed = false
            end
        else
            self.isPressed = false
            if self:isPointerInBounds(x, y) then
                self.onReleaseCallback()
            end
        end
    end,
    whilePressInternal = function(self, x, y, button)
    end
}
return Interactive
