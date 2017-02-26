local Frame = require "ui.frame"

local Image = class("Image", Frame)

function Image:initialize(posX, posY, pivotX, pivotY, width, height, sprite)
    Frame.initialize(self, posX, posY, pivotX, pivotY, width, height)
    self.sprite = sprite
    self.isAnim = false
    self.anim = nil
    self.animIsPlaying = false
end

function Image:setSprite(sprite)
    self.sprite = sprite
    return self
end

function Image:setSpriteType(value)
    if value == "normal" then self.isAnim = false
    elseif value == "anim" then self.isAnim = true end
    return self
end

function Image:setAnim(gridW, gridH, duration, onLoop, ...)
    self.isAnim = true
    self.gridW = gridW
    self.gridH = gridH
    local gs = anim8.newGrid(gridW, gridH, self.sprite:getWidth(), self.sprite:getHeight())
    local frames = gs(...)
    self.anim = anim8.newAnimation(frames, duration, onLoop)
    return self
end

function Image:setAnimPlayStatus(status)
    self.animIsPlaying = status
    return self
end

function Image:playAnim()

end

function Image:gotoFrame(frame)
    self.anim:gotoFrame(frame)
    return self
end

function Image:pause()
    self.anim:pause()
    return self
end

function Image:resume()
    self.anim:resume()
    return self
end

function Image:update(dt)
    if self.animIsPlaying then
        self.anim:update(dt)
    end
end

function Image:draw()
    if self.isAnim then
        self.anim:draw(self.sprite, self.absX, self.absY, 0, self.width/self.gridW, self.height/self.gridH)
    else
        love.graphics.draw(self.sprite, self.absX, self.absY, 0,
            self.width/self.sprite:getWidth(), self.height/self.sprite:getHeight())
    end
end

return Image
