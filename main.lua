
love.graphics.setDefaultFilter('nearest', 'nearest')

--[[
local Monocle = require "lib.monocle"
Monocle.new({
    isActive = true,
    customPrinter = false,
    printColor = {51, 51, 51},
    debugToggle = 'd',
    filesToWatch = { "game.lua" }
})

Monocle.watch("FPS", function() return math.floor(1/love.timer.getDelta()) end)
]]

class = require "lib.middleclass"
CScreen = require "lib.cscreen"
local inspect = require "lib.inspect"
local flux = require "lib.flux"
patchy = require "lib.patchy"
assets = require("lib.cargo").init("assets")
lui = require "ui.lui"
local Stack = require "utils.stack"
local autolove = require "utils.autolove"

lui:setRootSize(160, 240)

local states = {
    Game = require "game",
    Title = require "title",
}

local stateModules = {
    Game = "game.lua",
    Title = "title.lua",

}

local lastStateSave = {}
local lastHotModified

local gsm = Stack:new()

function stateCall(funcName, ...)
    for _, state in ipairs(gsm.elems) do
        if state[funcName] then state[funcName](state, ...) end
    end
end

function reloadGame()
    local currentStateName = gsm:peek().name
    gsm:pop()
    lui:clear()
    gsm:push(states[currentStateName]:new())
end


function love.load()
    CScreen.init(160, 240, true)
    lui:init({CScreen.getInfo()})
    gsm:push(states.Game:new())
    autolove:init(stateModules, states, reloadGame)
end

function love.update(dt)
    lui:update(dt)
    flux.update(dt)
    stateCall("update")
    --Monocle.update()
    autolove:update(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(255, 239, 138, 1)
    CScreen.apply()
    --frame:drawDebug()
    lui:draw()
    stateCall("draw")
    CScreen.cease()
    --Monocle.draw()
    love.graphics.setColor(255, 255, 255, 255)
end

function love.textinput(t)
    --Monocle.textinput(t)
end

function love.keypressed(key, scancode, isrepeat)
    stateCall("keypressed")
    if key == "r" then
        reloadGame()
    end
    --Monocle.keypressed(key)
end
function love.resize(width, height)
    CScreen.update(width, height)
    stateCall("resize")
end

function love.mousepressed(x, y, button, istouch)
    local tx, ty, fsv = CScreen.getInfo()
    lui:pressed(x/fsv - tx, y/fsv - ty, button)
    stateCall("mousepressed")
end

function love.mousereleased(x, y, button, istouch)
    local tx, ty, fsv = CScreen.getInfo()
    lui:released(x/fsv - tx, y/fsv - ty, button)
    stateCall("mousereleased")
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
