--require "lib.lovedebug"

love.graphics.setDefaultFilter('nearest', 'nearest')

require "lib.fun"()
require "utils.copy"
class = require "lib.middleclass"
CScreen = require "lib.cscreen"
inspect = require "lib.inspect"
flux = require "lib.flux"
patchy = require "lib.patchy"
assets = require("lib.cargo").init("assets")
anim8 = require "lib.anim8"
lui = require "ui.lui"
require "utils.errors"
Random = require "utils.random"
local Stack = require "utils.stack"
autolove = require "utils.autolove"

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
gsm.states = states

function stateCall(funcName, ...)
    local state = gsm:peek()
    if state[funcName] then state[funcName](state, ...) end
end

function reloadGame()
    local currentStateName = gsm:peek().name
    gsm:pop()
    lui:clear()
    gsm:push(states[currentStateName]:new(gsm))
end


function love.load()
    CScreen.init(160, 240, true)
    lui:init(CScreen.getInfo())
    gsm:push(states.Game:new(gsm))
    --autolove:init(stateModules, states, reloadGame)
    require("stat_calc")()
end

function love.update(dt)
    lui:update(dt)
    flux.update(dt)
    stateCall("update", dt)
    --Monocle.update()
    --autolove:update(dt)
end

function love.draw()
    CScreen.apply()
    --frame:drawDebug()
    stateCall("draw")
    lui:draw()
    CScreen.cease()
    --Monocle.draw()
    love.graphics.setColor(255, 255, 255, 255)
end

function love.textinput(t)
    --Monocle.textinput(t)
end

function love.keypressed(key, scancode, isrepeat)
    stateCall("keypressed", key, scancode, isrepeta)
    if key == "r" then
        require("stat_calc")()
    elseif key == "escape" then
        love.event.quit()
    end
    --Monocle.keypressed(key)
end
function love.resize(width, height)
    CScreen.update(width, height)
    stateCall("resize", width, height)
end

function love.mousepressed(x, y, button, istouch)
    local screenInfo = CScreen.getInfo()
    local ax = (x - screenInfo.tx)/screenInfo.fsv
    local ay = (y - screenInfo.ty)/screenInfo.fsv
    lui:pressed(ax, ay, button)
    stateCall("mousepressed", ax, ay, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
    local screenInfo = CScreen.getInfo()
    local ax = (x - screenInfo.tx)/screenInfo.fsv
    local ay = (y - screenInfo.ty)/screenInfo.fsv
    lui:released(ax, ay, button)
    stateCall("mousereleased", ax, ay, button, istouch)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    -- body...
end

function love.touchpressed(id, x, y, dx, dy, pressure)
    --love.mousepressed(x, y, 1)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    --love.mousereleased(x, y, 1)
end
