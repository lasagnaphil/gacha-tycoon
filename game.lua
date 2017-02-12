local Game = class("Game")

function Game:initialize()
    self.name = "Game"
    self.moduleName = "game.lua"
    self.ui = {}
    local buttonImages = {
        blue = {
            normal = patchy.load("assets/img/9-Slice/Colored/blue.png"),
            pressed = patchy.load("assets/img/9-Slice/Colored/blue_pressed.png")
        },
        green = {
            normal = patchy.load("assets/img/9-Slice/Colored/green.png"),
            pressed = patchy.load("assets/img/9-Slice/Colored/green.png")
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
    local defaultFont = love.graphics.newFont("assets/fonts/pokemon.ttf", 11)

    --[[
    self.ui.moneyPanel = lui.Panel:new(10, 10, 0, 0, 40, 40, buttonImages.pressed)
                        :setText("$1000")
                        :setFont(defaultFont)
                        ]]

    --local panelImage = patchy.load("img/blue_pressed.png")
    --panel = lui:newPanel(80, 120, 0.5, 0.5, 80, 120, panelImage)

    local glyphs = " abcdefghijklmnopqrstuvwxyz" ..
                  "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
                  "123456789.,!?-+/():;%&`'*#=[]\""
    --local defaultFont = love.graphics.newImageFont("assets/fonts/default.png", glyphs)

    self.ui.moneyPanel = lui:newPanel(10, 10, 0, 0, 40, 18, buttonImages.grey.pressed)
        :setText("$1000")
        :setFont(defaultFont, {0, 0, 0, 255})

    self.ui.ratingPanel = lui.ProgressBar:new(80, 19, 0.5, 0, 40, 10)
        :setText("Rating")
        :setFont(defaultFont, {255, 255, 255, 255})

    self.ui.numPeoplePanel = lui:newPanel(150, 10, 1, 0, 40, 18, buttonImages.grey.pressed)
        :setText("P: 100")
        :setFont(defaultFont, {0, 0, 0, 255})

    self.ui.openItemsButton = lui:newButton(10, 230, 0, 1, 45, 30, buttonImages.blue)
        :setText("Items")
        :setFont(defaultFont)

    self.ui.openBoxesButton = lui:newButton(80, 230, 0.5, 1, 45, 30, buttonImages.blue)
        :setText("Boxes")
        :setFont(defaultFont)

    self.ui.openStatsButton = lui:newButton(150, 230, 1, 1, 45, 30, buttonImages.blue)
        :setText("Stats")
        :setFont(defaultFont)

    --flux.to(frame, 4, { posX = 120, posY = 180 }):onupdate(function() frame:updatePos() end)
end

return Game
