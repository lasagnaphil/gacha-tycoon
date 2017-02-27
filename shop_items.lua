local shopItems = {
    path = "shop_items",
    {
        name = "Regular gacha box",
        type = "gacha",
        gachaType = "regular",
        img = "regular_gacha.png",
        description = "test your fate to get cool weapons and items!",
        isCash = true,
        cost = 5000,
        behavior = function(self, game)
            game:openGachaMenu()
            game.ui.gacha.type = "regular"
            game.ui.gacha.currentGachaItem = self
        end
    },
    {
        name = "Legendary gacha box",
        type = "gacha",
        gachaType = "legendary",
        img = "legendary_gacha.png",
        description = "the best weapons and items are at your fingertips!",
        isCash = true,
        cost = 100000,
        behavior = function(self, game)
            game:openGachaMenu()
            game.ui.gacha.type = "legendary"
            game.ui.gacha.currentGachaItem = self
        end
    },
    {
        name = "Revive sword",
        type = "gacha",
        img = "prevent_trash.png",
        description = "prevent weapons from breaking while upgrading",
        cost = 1000000,
        behavior = function(self, game)
            
        end
    }
}

return shopItems
