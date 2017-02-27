local Inventory = {
    items = {},
    itemDict = {}
}

function Inventory:addItem(name, amount)
    local amount = amount or 1
    if self.itemDict[name] == nil then
        error("Inventory:addItem(): Item " .. name .. " is not in item dictionary")
    end
    if self.items[name] == nil then
        self.items[name] = amount
    else
        self.items[name] = self.items[name] + amount
    end
    return true
end

function Inventory:addToDict(name, data)
    if type(name) == "string" then
        self.itemDict[name] = data
    elseif type(name) == "table" then
        local array = name
        for _, item in ipairs(array) do
            self.itemDict[item.name] = item
        end
    end
end

function Inventory:removeItem(name, amount)
    local amount = amount or 1
    if self.items[name] == nil then
        return false
    else
        if self.items[name] < amount then return false end
        self.items[name] = self.items[name] - amount
        if self.items[name] == 0 then
            self.items[name] = nil
        end
        return true
    end
    print(inspect(self.items))
end

function Inventory:getAllItems()
    --[[
    local allItems = {}
    for name, amount in pairs(self.items) do
        allItems[#allItems + 1] = {
            name = name,
            data = self.itemDict[name],
            amount = amount
        }
    end
    return allItems
    ]]
    return iter(self.items)
        :map(function(name, amount)
            return {
                name = name,
                data = self.itemDict[name],
                amount = amount
            }
        end)
        :totable()
end

return Inventory
