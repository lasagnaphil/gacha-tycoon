local Game = class("Game")

function Game:initialize()
    self.name = "Game"
    self.moduleName = "game.lua"

    self.gameMoney = 1000
    self.realMoney = 1000

    self.ui = {}

    self.items = {
        knives = require "knives"
    }

    -- load current items

    self.currentItem = self.items.knives[1]
    local currentItemPath = "assets/img/" .. self.items.knives.path .. "/" .. self.currentItem.img
    self.currentItemImage = love.graphics.newImage(currentItemPath)



    self.coloredImages = {
        blue = {
            normal = patchy.load("assets/img/9-Slice/Colored/blue.png"),
            pressed = patchy.load("assets/img/9-Slice/Colored/blue_pressed.png")
        },
        green = {
            normal = patchy.load("assets/img/9-Slice/Colored/green.png"),
            pressed = patchy.load("assets/img/9-Slice/Colored/green_pressed.png")
        },
        grey = {
            normal = patchy.load("assets/img/9-Slice/Colored/grey.png"),
            pressed = patchy.load("assets/img/9-Slice/Colored/grey_pressed.png")
        },
        red = {
            normal = patchy.load("assets/img/9-Slice/Colored/red.png"),
            pressed = patchy.load("assets/img/9-Slice/Colored/red_pressed.png")
        },
        yellow = {
            normal = patchy.load("assets/img/9-Slice/Colored/yellow.png"),
            pressed = patchy.load("assets/img/9-Slice/Colored/yellow_pressed.png")
        }
    }
    self.outlineImages = {
        blue = {
            normal = patchy.load("assets/img/9-Slice/Outline/blue.png"),
            pressed = patchy.load("assets/img/9-Slice/Outline/blue_pressed.png")
        },
        green = {
            normal = patchy.load("assets/img/9-Slice/Outline/green.png"),
            pressed = patchy.load("assets/img/9-Slice/Outline/green_pressed.png")
        },
        red = {
            normal = patchy.load("assets/img/9-Slice/Outline/red.png"),
            pressed = patchy.load("assets/img/9-Slice/Outline/red_pressed.png")
        },
        yellow = {
            normal = patchy.load("assets/img/9-Slice/Outline/yellow.png"),
            pressed = patchy.load("assets/img/9-Slice/Outline/yellow_pressed.png")
        }
    }
    self.koreanFont = love.graphics.newFont("assets/fonts/gulim.ttc", 11)
    self.defaultFont = love.graphics.newFont("assets/fonts/pokemon.ttf", 11)

    --[[
    self.ui.moneyPanel = lui.Panel:new(10, 10, 0, 0, 40, 40, buttonImages.pressed)
                        :setText("$1000")
                        :setFont(defaultFont)

    --local panelImage = patchy.load("img/blue_pressed.png")
    --panel = lui:newPanel(80, 120, 0.5, 0.5, 80, 120, panelImage)

    local glyphs = " abcdefghijklmnopqrstuvwxyz" ..
                  "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
                  "123456789.,!?-+/():;%&`'*#=[]\""
    ]]
    self:setupUI()
end

function Game:sellItem()

end

function Game:tryUpgradeItem()

end

function Game:setupUI()
    self.ui.timePanel = lui.Panel:new(10, 10, 0, 0, 50, 20, self.outlineImages.yellow.normal)
        :setText("Y 1 M 1 D 1")
        :setFont(self.defaultFont, {0, 0, 0, 255})

    self.ui.gameMoneyPanel = lui.Panel:new(150, 10, 1, 0, 45, 20, self.coloredImages.yellow.pressed)
        :setText("0 M")
        :setFont(self.defaultFont, {255, 255, 255, 255})
        :bindVar("text", function() return tostring(self.gameMoney) .. " M" end)

    self.ui.realMoneyPanel = lui.Panel:new(150, 30, 1, 0, 45, 20, self.coloredImages.yellow.pressed)
        :setText("0 Won")
        :setFont(self.defaultFont, {255, 255, 255, 255})
        :bindVar("text", function() return tostring(self.realMoney) .. " Won" end)

    self.ui.sellText = lui.Panel:new(80, 70, 0.5, 0.5, 100, 20)
        :setText("Sell for: 0 M", "center")
        :setFont(self.defaultFont, {0, 0, 0, 255})
        :bindVar("text", function() return "Sell for: " .. tostring(self.currentItem.value) .. " M" end)

    self.ui.upgradeCostText = lui.Panel:new(80, 85, 0.5, 0.5, 100, 20)
        :setText("Upgrade Cost: 0 M", "center")
        :setFont(self.defaultFont, {0, 0, 0, 255})
        :bindVar("text", function() return "Upgrade cost: " .. tostring(self.currentItem.upgradeCost) .. " M" end)

    self.ui.sellButton = lui.Button:new(10, 230, 0, 1, 45, 20, self.coloredImages.red)
        :setText("Sell")
        :setFont(self.defaultFont, {255, 255, 255, 255})

    self.ui.shopButton = lui.Button:new(80, 230, 0.5, 1, 45, 20, self.coloredImages.green)
        :setText("Shop")
        :setFont(self.defaultFont, {255, 255, 255, 255})

    self.ui.upgradeButton = lui.Button:new(150, 230, 1, 1, 45, 20, self.coloredImages.blue)
        :setText("Upgrade")
        :setFont(self.defaultFont, {255, 255, 255, 255})
end

function Game:update(dt)
end

function Game:draw()
    local w, h = self.currentItemImage:getWidth(), self.currentItemImage:getHeight()
    love.graphics.draw(self.currentItemImage, 80 - w/2, 140 - h/2)
end

return Game
