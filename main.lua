
love.graphics.setDefaultFilter('nearest', 'nearest')

local GameState = require "lib.gamestate"
local CScreen = require "lib.cscreen"
local inspect = require "lib.inspect"
local flux = require "lib.flux"
local patchy = require "lib.patchy"

assets = require("lib.cargo").init("assets")

local lui = require "ui.lui"

lui:setRootSize(160, 240)

local frame
local frame2
local panel
local button

function love.load()
    CScreen.init(160, 240, true)

    frame = lui:newFrame(80, 120, 0.5, 0.5, 80, 120)
    frame2 = lui:newFrame(0, 0, 0, 0, 40, 40)
    frame2:setParent(frame)

    --local panelImage = patchy.load("img/blue_pressed.png")
    --panel = lui:newPanel(80, 120, 0.5, 0.5, 80, 120, panelImage)

    local buttonImages = {
        normal = patchy.load("assets/img/blue.png"),
        pressed = patchy.load("assets/img/blue_pressed.png")
    }
    local glyphs = " abcdefghijklmnopqrstuvwxyz" ..
                  "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
                  "123456789.,!?-+/():;%&`'*#=[]\""
    --local defaultFont = love.graphics.newImageFont("assets/fonts/default.png", glyphs)
    local defaultFont = love.graphics.newFont("assets/fonts/pokemon.ttf", 10)
    button = lui:newButton(80, 120, 0.5, 0.5, 60, 30, buttonImages)
                :setText("Hello")
                :setFont(defaultFont)

    --flux.to(frame, 4, { posX = 120, posY = 180 }):onupdate(function() frame:updatePos() end)
end

function love.update(dt)
    flux.update(dt)
end

function love.draw()
    CScreen.apply()
    --frame:drawDebug()
    lui:draw()
    CScreen.cease()
end

function love.resize(width, height)
    CScreen.update(width, height)
end

function love.mousepressed(x, y, button, istouch)
    local tx, ty, fsv = CScreen.getInfo()
    lui:pressed(x/fsv - tx, y/fsv - ty, button)
end

function love.mousereleased(x, y, button, istouch)
    local tx, ty, fsv = CScreen.getInfo()
    lui:released(x/fsv - tx, y/fsv - ty, button)

end

function love.touchmoved(id, x, y, dx, dy, pressure)
    -- body...
end

function love.touchpressed(id, x, y, dx, dy, pressure)
    -- body...
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    -- body...
end
