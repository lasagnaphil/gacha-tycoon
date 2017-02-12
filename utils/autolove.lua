local Autolove = {}

local Status = {
    None = 1,
    Debug = 2,
    Error = 3
}

function Autolove:init(modules, classdata, reloadCallback)
    --[[
    local modules = {
        Game = "game.lua",
        Title = "title.lua"
    }
    ]]

    self.reloadCallback = reloadCallback
    self.modules = modules
    self.lastModTime = {}
    self.classdata = classdata

    self.status = Status.None

    self.text = ""
    self.font = love.graphics.newFont(12)

    for class, path in pairs(self.modules) do
        classdata[class] = love.filesystem.load(path)()
    end

end

function Autolove:update(dt)
    for class, path in pairs(self.modules) do
        local modtime, err = love.filesystem.getLastModified(path)
        local isChanged = false
        if self.lastModTime[class] ~= modtime then
            isChanged = true
            self.lastModTime[class] = modtime
            local ok, loadedModule = pcall(love.filesystem.load, path)
            if ok then
                print("class " .. class .. " reloaded")
                self.classdata[class] = loadedModule()
            else
                print("Error while loading " .. class .. ": " .. loadedModule)
            end
        end
        if isChanged then
            self.reloadCallback(self)
        end
    end
end

function Autolove:refresh()
    for class, path in pairs(self.modules) do
        classdata[class] = love.filesystem.load(path)()
    end
end

function Autolove:draw()
    if self.status == Status.None then

    elseif self.status == Status.Debug then

    elseif self.status == Status.Error then

    end
end

return Autolove
