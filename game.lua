local Game = class("Game")

function Game:initialize()
    self.name = "Game"
    self.moduleName = "game.lua"

    self.gameMoney = 1000
    self.realMoney = 1000

    self.ui = {}
    self.shopMenuOpened = false
    self.upgradeFailed = false

    self.noImgSprite = love.graphics.newImage("assets/img/no-image.png")
    -- current type of item
    self.curItemType = "swords"

    self.items = {
        swords = require "swords",
        shopItems = require "shop_items"
    }

    self.inventory = require "inventory"

    for kind, items in pairs(self.items) do
        for _, item in ipairs(items) do
            if item.img then
                local currentItemPath = "assets/img/" .. items.path .. "/" .. item.img
                item.loadedImg = love.graphics.newImage(currentItemPath)
            else
                item.loadedImg = self.noImgSprite
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

    self.shopMenuOpened = false
    self.invMenuOpened = false
    self.lowerButtonsEnabled = true
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
    self.lowerButtonsEnabled = not self.shopMenuOpened
end

function Game:toggleInvMenu()
    self.shopMenuOpened = false
    self.invMenuOpened = not self.invMenuOpened
    self.lowerButtonsEnabled = not self.invMenuOpened
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

function Game:keepItem()
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
            return not self.upgradeFailed and self.lowerButtonsEnabled
        end)

    self.ui.keepButton = lui.Button:new(80, 230, 0.5, 1, 45, 20, self.coloredImages.green)
        :setText("Keep")
        :setFont(self.defaultFont, {255, 255, 255, 255})
        :onPress(function() self:keepItem() end)
        :bindVar("isEnabled", function()
            return not self.upgradeFailed and self.lowerButtonsEnabled
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
        :bindVar("isEnabled", function() return self.lowerButtonsEnabled end)

    local shopWidth, shopHeight = 140, 190
    self.ui.shopMenu = lui.Panel:new(80, 135, 0.5, 0.5, shopWidth, shopHeight, self.outlineImages.yellow.pressed)
        :bindVar("isEnabled", function() return self.shopMenuOpened end, lui.Frame.setEnable)
        :setEnable(false)

    self.ui.shop = {}

    self.ui.shop.titleText = lui.Panel:new(shopWidth/2, 5, 0.5, 0, 40, 15)
        :setText("Shop")
        :setFont(self.defaultFont, Color.BLACK)
        :setParent(self.ui.shopMenu)

    self.ui.shop.itemList = lui.ScrollList:new(shopWidth/2, 20, 0.5, 0, 120, 120, self.outlineImages.yellow.pressed)
        :setParent(self.ui.shopMenu)
        :setEntryHeight(30)
        :setEnable(false)

    self.ui.shop.selectedItemPanel = nil
    self.ui.shop.selectedItem = nil
    self.ui.shop.newItemPanel = function(item)
        local panel = lui.Button:new(0, 0, 0, 0, 100, 100, self.outlineImages.blue)
            :setText(item.name .. "\t", "right")
            :setFont(self.defaultFont, Color.BLACK)

        panel:onPress(function()
            panel:setSpritePatches(self.outlineImages.red)
            self.ui.shop.selectedItemPanel = panel
            self.ui.shop.selectedItem = item
            for _, itemPanel in ipairs(self.ui.shop.items) do
                if itemPanel ~= panel then
                    itemPanel:setSpritePatches(self.outlineImages.blue)
                end
            end
        end)

        local icon = lui.Image:new(15, 15, 0.5, 0.5, 16, 16, item.loadedImg or self.noImgSprite)
            :setParent(panel)

        panel.item = item

        return panel
    end

    self.ui.shop.updateItems = function()
        self.ui.shop.items = iter(self.items.shopItems)
            :map(function(item)
                local panel = self.ui.shop.newItemPanel(item)
                self.ui.shop.itemList:addEntry(panel)
                return panel
            end)
            :totable()
    end
    self.ui.shop.updateItems()

    self.ui.shop.descriptionText = "<description>"
    self.ui.shop.description = lui.Panel:new(shopWidth/2, shopHeight-24, 0.5, 1, shopWidth*0.8, shopHeight*0.2)
        :setText(self.ui.shop.descriptionText)
        :setFont(self.minimalFont, Color.BLACK)
        :setParent(self.ui.shopMenu)
        :bindVar("text", function() return self.ui.shop.descriptionText end)

    self.ui.shop.description = lui.Panel:new(10, shopHeight-9, 0, 1, shopWidth*0.3, 10)
        :setText("cost: 1000", "left")
        :setFont(self.minimalFont, Color.BLACK)
        :setParent(self.ui.shopMenu)
        :bindVar("text", function()
            if self.ui.shop.selectedItem == nil then return "" end
            return "cost: " .. (self.ui.shop.selectedItem.cost or "none")
        end)

    self.ui.shop.buyButton = lui.Button:new(shopWidth-5, shopHeight-5, 1, 1, 40, 20, self.outlineImages.blue)
        :setText("Buy")
        :setFont(self.defaultFont, Color.BLACK)
        :setParent(self.ui.shopMenu)
        :onPress(function()
        end)

    local invWidth, invHeight = 140, 160

    self.ui.invMenu = lui.Panel:new(80, 120, 0.5, 0.5, invWidth, invHeight, self.outlineImages.green.pressed)
        :bindVar("isEnabled", function() return self.invMenuOpened end, lui.Frame.setEnable)
        :setEnable(false)

    self.ui.inv = {}

    self.ui.inv.titleText = lui.Panel:new(invWidth/2, 5, 0.5, 0, 40, 15)
        :setText("Inventory")
        :setFont(self.defaultFont, Color.BLACK)
        :setParent(self.ui.invMenu)

    self.ui.inv.itemList = lui.ScrollGrid:new(invWidth/2, 20, 0.5, 0, 120, 90, self.outlineImages.yellow.pressed)
        :setParent(self.ui.invMenu)
        :setEntrySize(32, 32)
        :setEnable(false)

    self.ui.inv.itemList:addDefaultEntry(self.outlineImages.yellow.pressed, "H", self.minimalFont, Color.BLACK)
                        :addDefaultEntry(self.outlineImages.yellow.pressed, "H", self.minimalFont, Color.BLACK)
                        :addDefaultEntry(self.outlineImages.yellow.pressed, "H", self.minimalFont, Color.BLACK)
                        :addDefaultEntry(self.outlineImages.yellow.pressed, "H", self.minimalFont, Color.BLACK)
                        :addDefaultEntry(self.outlineImages.yellow.pressed, "H", self.minimalFont, Color.BLACK)
                        :addDefaultEntry(self.outlineImages.yellow.pressed, "H", self.minimalFont, Color.BLACK)
                        :addDefaultEntry(self.outlineImages.yellow.pressed, "H", self.minimalFont, Color.BLACK)
                        :addDefaultEntry(self.outlineImages.yellow.pressed, "H", self.minimalFont, Color.BLACK)
                        :addDefaultEntry(self.outlineImages.yellow.pressed, "H", self.minimalFont, Color.BLACK)
                        :addDefaultEntry(self.outlineImages.yellow.pressed, "H", self.minimalFont, Color.BLACK)
                        :addDefaultEntry(self.outlineImages.yellow.pressed, "H", self.minimalFont, Color.BLACK)
                        :addDefaultEntry(self.outlineImages.yellow.pressed, "H", self.minimalFont, Color.BLACK)
                        :addDefaultEntry(self.outlineImages.yellow.pressed, "H", self.minimalFont, Color.BLACK)
                        :addDefaultEntry(self.outlineImages.yellow.pressed, "H", self.minimalFont, Color.BLACK)
                        :addDefaultEntry(self.outlineImages.yellow.pressed, "H", self.minimalFont, Color.BLACK)
                        :addDefaultEntry(self.outlineImages.yellow.pressed, "H", self.minimalFont, Color.BLACK)
                        :addDefaultEntry(self.outlineImages.yellow.pressed, "H", self.minimalFont, Color.BLACK)
                        :addDefaultEntry(self.outlineImages.yellow.pressed, "H", self.minimalFont, Color.BLACK)
                        :addDefaultEntry(self.outlineImages.yellow.pressed, "H", self.minimalFont, Color.BLACK)
                        :addDefaultEntry(self.outlineImages.yellow.pressed, "H", self.minimalFont, Color.BLACK)
                        :addDefaultEntry(self.outlineImages.yellow.pressed, "H", self.minimalFont, Color.BLACK)

    self.ui.inv.description = lui.Panel:new(invWidth/2, invHeight-24, 0.5, 1, invWidth*0.8, invHeight*0.2)
        :setText("do something that is totally crazy")
        :setFont(self.minimalFont, Color.BLACK)
        :setParent(self.ui.invMenu)

    self.ui.inv.sellButton = lui.Button:new(invWidth-45, invHeight-5, 1, 1, 40, 20, self.outlineImages.blue)
        :setText("Sell")
        :setFont(self.defaultFont, Color.BLACK)
        :setParent(self.ui.invMenu)

    self.ui.inv.useButton = lui.Button:new(invWidth-5, invHeight-5, 1, 1, 40, 20, self.outlineImages.blue)
        :setText("Use")
        :setFont(self.defaultFont, Color.BLACK)
        :setParent(self.ui.invMenu)

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
