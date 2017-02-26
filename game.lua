local Game = class("Game")

function Game:initialize()
    self.name = "Game"
    self.moduleName = "game.lua"

    self.gameMoney = 300000
    self.realMoney = 10000

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

    require "stat_calc"()

    for i, item in ipairs(self.items.swords) do
        item.type = "sword"
        item.level = i
    end

    self.inventory = require "inventory"
    for _, itemList in pairs(self.items) do
        self.inventory:addToDict(itemList)
    end

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

function Game:addMoney(money)
    self.gameMoney = self.gameMoney + money
end

function Game:useMoney(money)
    if self.gameMoney < money then return false
    else
        self.gameMoney = self.gameMoney - money
        return true
    end
end

function Game:sellCurrentItem()
    self:addMoney(self.curItem.value)
    self:setItem(1)
    self.gameMoney = self.gameMoney - self.items[self.curItemType][1].value
end

function Game:keepCurrentItem()
    self.inventory:addItem(self.curItem.name)
    self:setItem(1)
    self.gameMoney = self.gameMoney - self.items[self.curItemType][1].value
end

function Game:sellItemInInventory(item)
    local result = self.inventory:removeItem(item.name, 1)
    if result then
        self:addMoney(item.value or 0)
    end
    self.ui.inv.updateItems()
end

function Game:toggleShopMenu()
    self.invMenuOpened = false
    self.shopMenuOpened = not self.shopMenuOpened
    self.lowerButtonsEnabled = not self.shopMenuOpened
    if self.shopMenuOpened then
        self.ui.shop.updateItems()
    end
end

function Game:toggleInvMenu()
    self.shopMenuOpened = false
    self.invMenuOpened = not self.invMenuOpened
    self.lowerButtonsEnabled = not self.invMenuOpened
    if self.invMenuOpened then
        self.ui.inv.updateItems()
    end
end

function Game:tryUpgradeItem()
    if self:useMoney(self.curItem.upgradeCost) then
        local randNum = math.random()
        if randNum <= self.curItem.prob then
            self:setItem(self.curItemIndex + 1)
        else
            self.upgradeFailed = true
        end
    end
end


function Game:setupUI()
    self:setupMainUI()
    self:setupShopUI()
    self:setupInvUI()
end

local Color = {
    WHITE = {255, 255, 255, 255},
    BLACK = {0, 0, 0, 255}
}

function Game:setupMainUI()
    --[[
    self.ui.timePanel = lui.Panel:new(10, 10, 0, 0, 50, 20, self.outlineImages.yellow.normal)
        :setText("Y 1 M 1 D 1")
        :setFont(self.defaultFont, {0, 0, 0, 255})
        ]]

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
        :onPress(function() self:sellCurrentItem() end)
        :bindVar("isEnabled", function()
            return not self.upgradeFailed and self.lowerButtonsEnabled
        end)

    self.ui.keepButton = lui.Button:new(80, 230, 0.5, 1, 45, 20, self.coloredImages.green)
        :setText("Keep")
        :setFont(self.defaultFont, {255, 255, 255, 255})
        :onPress(function() self:keepCurrentItem() end)
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
end

function Game:setupShopUI()
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
            if self.ui.shop.selectedItemPanel then
                self.ui.shop.selectedItemPanel:setSpritePatches(self.outlineImages.blue)
            end
            panel:setSpritePatches(self.outlineImages.red)
            self.ui.shop.selectedItemPanel = panel
            self.ui.shop.selectedItem = item
        end)

        local icon = lui.Image:new(15, 15, 0.5, 0.5, 16, 16, item.loadedImg or self.noImgSprite)
            :setParent(panel)

        panel.item = item

        self.ui.shop.itemList:addEntry(panel)

        return panel
    end

    self.ui.shop.updateItems = function()
        self.ui.shop.selectedItemPanel = nil
        self.ui.shop.selectedItem = nil
        self.ui.shop.itemList:clear()
        self.ui.shop.items = iter(self.items.shopItems)
            :map(function(item)
                return self.ui.shop.newItemPanel(item)
            end)
            :totable()
    end

    self.ui.shop.description = lui.Panel:new(shopWidth/2, shopHeight-24, 0.5, 1, shopWidth*0.8, shopHeight*0.2)
        :setText(self.ui.shop.descriptionText)
        :setFont(self.minimalFont, Color.BLACK)
        :setParent(self.ui.shopMenu)
        :bindVar("text", function()
            if self.ui.shop.selectedItem == nil then return "" end
            return self.ui.shop.selectedItem.description or "<description>"
        end)

    self.ui.shop.costPanel = lui.Panel:new(10, shopHeight-9, 0, 1, shopWidth*0.7, 10)
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
            if self.ui.shop.selectedItem then
                if self:useMoney(self.ui.shop.selectedItem.cost) then
                    self.inventory:addItem(self.ui.shop.selectedItem.name)
                end
            end
        end)
end

function Game:setupInvUI()
    local invWidth, invHeight = 140, 190

    self.ui.invMenu = lui.Panel:new(80, 135, 0.5, 0.5, invWidth, invHeight, self.outlineImages.green.pressed)
        :bindVar("isEnabled", function() return self.invMenuOpened end, lui.Frame.setEnable)
        :setEnable(false)

    self.ui.inv = {}
    self.ui.inv.items = {}

    self.ui.inv.titleText = lui.Panel:new(invWidth/2, 5, 0.5, 0, 40, 15)
        :setText("Inventory")
        :setFont(self.defaultFont, Color.BLACK)
        :setParent(self.ui.invMenu)

    self.ui.inv.itemList = lui.ScrollGrid:new(invWidth/2, 20, 0.5, 0, 120, 120, self.outlineImages.yellow.pressed)
        :setParent(self.ui.invMenu)
        :setEntrySize(24, 24)
        :setEnable(false)

    self.ui.inv.selectedItem = nil
    self.ui.inv.selectedItemPanel = nil

    self.ui.inv.newItemPanel = function(item)
        local panel = lui.Button:new(0, 0, 0, 0, 100, 100, self.outlineImages.blue)

        panel:onPress(function()
            if self.ui.inv.selectedItemPanel then
                self.ui.inv.selectedItemPanel:setSpritePatches(self.outlineImages.blue)
            end
            panel:setSpritePatches(self.outlineImages.red)
            self.ui.inv.selectedItemPanel = panel
            self.ui.inv.selectedItem = item
        end)

        local icon = lui.Image:new(12, 12, 0.5, 0.5, 16, 16, item.loadedImg or self.noImgSprite)
            :setParent(panel)

        panel.item = item

        self.ui.inv.itemList:addEntry(panel)
    end

    self.ui.inv.updateItems = function()
        self.ui.inv.selectedItemPanel = nil
        self.ui.inv.selectedItem = nil
        self.ui.inv.itemList:clear()
        print(inspect(self.inventory:getAllItems()))
        self.ui.inv.items = iter(self.inventory:getAllItems())
            :map(function(item)
                return self.ui.inv.newItemPanel(item.data)
            end)
            :totable()
    end

    self.ui.inv.description = lui.Panel:new(invWidth/2, invHeight-24, 0.5, 1, invWidth*0.8, invHeight*0.2)
        :setText("<description>")
        :setFont(self.minimalFont, Color.BLACK)
        :setParent(self.ui.invMenu)
        :bindVar("text", function()
            if self.ui.inv.selectedItem then
                if self.ui.inv.selectedItem.type == "sword" then
                    local level = self.ui.inv.selectedItem.level
                    local name = self.ui.inv.selectedItem.name
                    return "level " .. tostring(level).. "   \"" .. string.lower(name) .. "\""
                else return self.ui.inv.selectedItem.description end
            else return "" end
        end)

    self.ui.inv.sellButton = lui.Button:new(invWidth-45, invHeight-5, 1, 1, 40, 20, self.outlineImages.blue)
        :setText("Sell")
        :setFont(self.defaultFont, Color.BLACK)
        :setParent(self.ui.invMenu)
        :bindVar("text", function()
            return self.ui.inv.selectedItem and self.ui.inv.selectedItem.value end, lui.Frame.setEnable
        )
        :onPress(function()
            if self:useMoney(self.ui.inv.selectedItem.value) then
                self.inventory:removeItem(self.ui.inv.selectedItem.name)
            end
        end)

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
