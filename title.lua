local Title = class("Title")

function Title:initialize(gsm)
    self.gsm = gsm

    self.name = "Title"
    self.moduleName = "title.lua"

    self.image = love.graphics.newImage("assets/img/title-main.png")
    self.font = love.graphics.newFont("assets/fonts/pokemon.ttf", 11)
end

function Title:draw()
    love.graphics.draw(self.image)
    love.graphics.setFont(self.font)
    love.graphics.printf("Press anywhere to start!", 80 - 100/2, 150, 100, "center")
end

function Title:mousepressed(x, y, button)
    if button == 1 then
        self.gsm:pop()
        self.gsm:push(self.gsm.states.Game:new(self.gsm))
    end
end

return Title
