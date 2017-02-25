local Frame = require "ui.frame"

local Image = class("Image", Frame)

function Image:initialize(posX, posY, pivotX, pivotY, width, height, sprite)
    Frame.initialize(self, posX, posY, pivotX, pivotY, width, height)
    self.sprite = sprite
end

function Image:setSprite(sprite)
    self.sprite = sprite
    return self
end

function Image:draw()
    love.graphics.draw(self.sprite, self.absX, self.absY, 0,
        self.width/self.sprite:getWidth(), self.height/self.sprite:getHeight())
end

return Image
