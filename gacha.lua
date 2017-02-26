local Gacha = class("Gacha")

function Gacha:initialize(gsm)
    self.gsm = gsm

    self.sceneEnded = false
    self.gacha = {
        img = love.graphics.newImage("assets/img/gacha1.png"),
        x = 80, y = 120,
        w = 64, h = 64,
        scaleX = 1, scaleY = 1,
        pressed = false
    }
end

function Gacha:update(dt)
    if self.sceneEnded then
        self.gsm:pop()
        --[[
        local currentState = self.gsm:peek()
        if currentState.name == "Game" then
            currentState.invMenuOpened = true
        end
        ]]
    end
end

function Gacha:mousepressed(x, y, button)
    if not self.gacha.pressed then
        if self.gacha.x - self.gacha.w/2 <= x and x <= self.gacha.x + self.gacha.w/2 and
           self.gacha.y - self.gacha.h/2 <= y and y <= self.gacha.y + self.gacha.h/2 then
            flux.to(self.gacha, 2, { scaleX = 2, scaleY = 2})
                :oncomplete(function() self.sceneEnded = true end)
        end
    end

end
function Gacha:draw()
    love.graphics.setBackgroundColor(255, 239, 138, 1)

    love.graphics.draw(self.gacha.img, 80 - self.gacha.w/2, 120 - self.gacha.h/2, 0,
        self.gacha.scaleX, self.gacha.scaleY)
end

return Gacha
