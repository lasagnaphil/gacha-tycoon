local Interactive = {
    initialize = function(self)
        self.interactive = true
        self.isPressed = false
        self.onPressCallback = function() end
        self.onReleaseCallback = function() end
        lui:addInteractiveFrame(self)
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
            if self.spritePatches then self.sprite = self.spritePatches.pressed end
            self.onPressCallback()
        end
    end,
    onReleaseInternal = function(self, x, y, button)
        if self.spritePatches then self.sprite = self.spritePatches.normal end
        self.isPressed = false
        if self:isPointerInBounds(x, y) then
            self.onReleaseCallback()
        end
    end,
    whilePressInternal = function(self, x, y, button)
    end
}
return Interactive
