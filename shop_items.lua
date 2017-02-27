local shopItems = {
    path = "shop_items",
    {
        name = "Regular gacha box",
        type = "gacha",
        gachaType = "regular",
        img = "regular_gacha.png",
        description = "test your fate to get cool weapons and items!",
        cash = true,
        cost = 5000
    },
    {
        name = "Legendary gacha box",
        type = "gacha",
        gachaType = "legendary",
        img = "legendary_gacha.png",
        description = "the best weapons and items are at your fingertips!",
        cash = true,
        cost = 100000
    }
}

return shopItems
