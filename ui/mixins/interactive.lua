local Interactive = {
    interactiveInit = function(self)
        self.interactive = true
        self.onPressCallback = function() end
        self.onReleaseCallback = function() end
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
    onPressInternal = function(self, x, y, button)
        if self:isPointerInBounds(x, y) then
            self.sprite = self.spritePatches.pressed
            self.onPressCallback()
        end
    end,
    onReleaseInternal = function(self, x, y, button)
        self.sprite = self.spritePatches.normal
        if self:isPointerInBounds(x, y) then
            self.onReleaseCallback()
        end
    end
}
return Interactive
