local Game = class("Game")

local Inventory = require "inventory"

function Game:initialize()
    self.name = "Game"
    self.moduleName = "game.lua"

    self.gameMoney = 1000
    self.realMoney = 1000

    self.ui = {}
    self.shopMenuOpened = false
    self.upgradeFailed = false

    -- current type of item
    self.curItemType = "swords"

    self.items = {
        swords = require "swords"
    }

    self.inventory = Inventory:new()

    for kind, items in pairs(self.items) do
        for _, item in ipairs(items) do
            if item.img then
                local currentItemPath = "assets/img/" .. items.path .. "/" .. item.img
                item.loadedImg = love.graphics.newImage(currentItemPath)
            else
                item.loadedImg = love.graphics.newImage("assets/img/no-image.png")
            end
        end
    end

    -- randomize seed
    math.randomseed(os.time())

    -- load current items
    self.curItemIndex = 1
    self.curItem = self.items[self.curItemType][self.curItemIndex]

    -- images for ui
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

    -- fonts
    local glyphs = 'abcdefghijklmnopqrstuvwxyz"\'`-_/1234567890!?[](){}.,;:<>+=%#^*~ '

    self.koreanFont = love.graphics.newFont("assets/fonts/gulim.ttc", 11)
    self.defaultFont = love.graphics.newFont("assets/fonts/pokemon.ttf", 11)
    self.minimalFont = love.graphics.newImageFont("assets/fonts/minimal.png", glyphs, 1)

    -- image shown when upgrade fails
    self.upgradeFailedImage = love.graphics.newImage("assets/img/trash.png")
    --[[
    self.ui.moneyPanel = lui.Panel:new(10, 10, 0, 0, 40, 40, buttonImages.pressed)
                        :setText("$1000")
                        :setFont(defaultFont)

    --local panelImage = patchy.load("img/blue_pressed.png")
    --panel = lui:newPanel(80, 120, 0.5, 0.5, 80, 120, panelImage)

    ]]
    self:setupUI()
end

function Game:setItem(arg)
    if type(arg) == "number" then
        self.curItemIndex = arg
    elseif type(arg) == "string" then
        for i, item in ipairs(self.items[self.curItemType]) do
            if item.name == arg then
                self.curItemIndex = i
                break
            end
        end
    end
    if self.items[self.curItemType][self.curItemIndex] ~= nil then
        self.curItem = self.items[self.curItemType][self.curItemIndex]
    end
end

function Game:sellItem()
    self.gameMoney = self.gameMoney + self.curItem.value
    self:setItem(1)
    self.gameMoney = self.gameMoney - self.items[self.curItemType][1].value
end

function Game:toggleShopMenu()
    self.invMenuOpened = false
    self.shopMenuOpened = not self.shopMenuOpened
end

function Game:toggleInvMenu()
    self.shopMenuOpened = false
    self.invMenuOpened = not self.invMenuOpened
end

function Game:tryUpgradeItem()
    self.gameMoney = self.gameMoney - self.curItem.upgradeCost
    local randNum = math.random()
    if randNum <= self.curItem.prob then
        self:setItem(self.curItemIndex + 1)
    else
        self.upgradeFailed = true
    end
end

function Game:setupUI()

    --[[
    self.ui.timePanel = lui.Panel:new(10, 10, 0, 0, 50, 20, self.outlineImages.yellow.normal)
        :setText("Y 1 M 1 D 1")
        :setFont(self.defaultFont, {0, 0, 0, 255})
        ]]

    local Color = {
        WHITE = {255, 255, 255, 255},
        BLACK = {0, 0, 0, 255}
    }

    self.ui.shopButton = lui.Button:new(10, 10, 0, 0, 45, 20, self.coloredImages.yellow)
        :setText("Shop")
        :setFont(self.defaultFont, Color.WHITE)
        :onPress(function() self:toggleShopMenu() end)

    self.ui.inventoryButton = lui.Button:new(80, 10, 0.5, 0, 45, 20, self.coloredImages.yellow)
        :setText("Inventory")
        :setFont(self.defaultFont, Color.WHITE)
        :onPress(function() self:toggleInvMenu() end)

    self.ui.gameMoneyPanel = lui.Panel:new(150, 5, 1, 0, 45, 20)
        :setText("0 M", "right")
        :setFont(self.defaultFont, Color.BLACK)
        :bindVar("text", function() return tostring(self.gameMoney) .. " M" end)

    self.ui.realMoneyPanel = lui.Panel:new(150, 20, 1, 0, 45, 20)
        :setText("0 Won", "right")
        :setFont(self.defaultFont, Color.BLACK)
        :bindVar("text", function() return tostring(self.realMoney) .. " Won" end)

    self.ui.itemNameText = lui.Panel:new(80, 65, 0.5, 0.5, 200, 20)
        :setText("Level 1 Sword \"Shitty Sword\"")
        :setFont(self.defaultFont, {0, 0, 0, 255})
        :bindVar("text", function()
            return "Level " .. tostring(self.curItemIndex) .. "   \"" .. self.curItem.name .."\""
        end)

    self.ui.sellCostText = lui.Panel:new(80, 80, 0.5, 0.5, 100, 20)
        :setText("Sell for: 0 M", "center")
        :setFont(self.defaultFont, {0, 0, 0, 255})
        :bindVar("text", function() return "Sell for: " .. tostring(self.curItem.value) .. " M" end)

    self.ui.upgradeCostText = lui.Panel:new(80, 95, 0.5, 0.5, 100, 20)
        :setText("Upgrade Cost: 0 M", "center")
        :setFont(self.defaultFont, {0, 0, 0, 255})
        :bindVar("text", function()
            return "Upgrade cost: " .. tostring(self.curItem.upgradeCost) .. " M"
        end)

    self.ui.probabilityText = lui.Panel:new(80, 110, 0.5, 0.5, 100, 20)
        :setText("Probablity: 0%")
        :setFont(self.defaultFont, {0, 0, 0, 255})
        :bindVar("text", function() return "Probability: " .. tostring(math.floor(self.curItem.prob * 100)) .. "%" end)

    self.ui.sellButton = lui.Button:new(10, 230, 0, 1, 45, 20, self.coloredImages.red)
        :setText("Sell")
        :setFont(self.defaultFont, {255, 255, 255, 255})
        :onPress(function() self:sellItem() end)
        :bindVar("isEnabled", function()
            return not self.upgradeFailed
        end)

    self.ui.keepButton = lui.Button:new(80, 230, 0.5, 1, 45, 20, self.coloredImages.green)
        :setText("Keep")
        :setFont(self.defaultFont, {255, 255, 255, 255})
        :onPress(function() self:keepItem() end)
        :bindVar("isEnabled", function()
            return not self.upgradeFailed
        end)

    self.ui.upgradeButton = lui.Button:new(150, 230, 1, 1, 45, 20, self.coloredImages.blue)
        :setText("Upgrade")
        :setFont(self.defaultFont, {255, 255, 255, 255})
        :onPress(function()
            if self.upgradeFailed then
                self.upgradeFailed = false
                self:setItem(1)
            else
                self:tryUpgradeItem()
            end
        end)
        :bindVar("text", function()
            if self.upgradeFailed then return "Retry?"
            else return "Upgrade" end
        end)

    local shopWidth, shopHeight = 140, 160
    self.ui.shopMenu = lui.Panel:new(80, 120, 0.5, 0.5, shopWidth, shopHeight, self.outlineImages.yellow.pressed)
        :bindVar("isEnabled", function()
            return self.shopMenuOpened
        end)

    self.ui.shop = {}

    self.ui.shop.titleText = lui.Panel:new(shopWidth/2, 5, 0.5, 0, 40, 15)
        :setText("Shop")
        :setFont(self.defaultFont, Color.BLACK)
        :setParent(self.ui.shopMenu)

    self.ui.shop.itemList = lui.ScrollList:new(shopWidth/2, 20, 0.5, 0, 120, 90, self.outlineImages.yellow.pressed)
        :setParent(self.ui.shopMenu)
        :setEntryHeight(30)

    self.ui.shop.items = {
        lui.Panel:new()
            :setSpritePatch(self.outlineImages.blue.pressed)
            :setText("Hello world!")
            :setFont(self.defaultFont, Color.BLACK)
    }

    for _, item in ipairs(self.ui.shop.items) do
        self.ui.shop.itemList:addEntry(item)
    end

    self.ui.shop.description = lui.Panel:new(shopWidth/2, shopHeight-24, 0.5, 1, shopWidth*0.8, shopHeight*0.2)
        :setText("do something that is totally crazy")
        :setFont(self.minimalFont, Color.BLACK)
        :setParent(self.ui.shopMenu)

    self.ui.shop.buyButton = lui.Button:new(shopWidth-5, shopHeight-5, 1, 1, 40, 20, self.outlineImages.blue)
        :setText("Buy")
        :setFont(self.defaultFont, Color.BLACK)
        :setParent(self.ui.shopMenu)

    self.ui.invMenu = lui.Panel:new(80, 120, 0.5, 0.5, 140, 160, self.outlineImages.green.pressed)
        :bindVar("isEnabled", function() return self.invMenuOpened end)

end

function Game:update(dt)
end

function Game:draw()
    if self.upgradeFailed then
        love.graphics.printf("Upgrade Failed!", 80 - 100/2, 180, 100, "center")
        local w, h = self.upgradeFailedImage:getWidth(), self.upgradeFailedImage:getHeight()
        love.graphics.draw(self.upgradeFailedImage, 80 - w/2, 160 - h/2)
    else
        local w, h = self.curItem.loadedImg:getWidth(), self.curItem.loadedImg:getHeight()
        love.graphics.draw(self.curItem.loadedImg, 80 - w/2, 160 - h/2)
    end
end

return Game
