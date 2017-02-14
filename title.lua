local Title = class("Title")

function Title:initialize()
    self.name = "Title"
    self.moduleName = "title.lua"

    self.image = love.graphics.newImage("img/title-main.png")
end

function Title:draw()
    love.graphics.draw(self.image)
end

return Title
