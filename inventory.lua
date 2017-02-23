local Inventory = {
    items = {},
    itemDict = {}
}

function Inventory:addItem(name, amount)
    assert(type(name) == "string" and type(data) == "table" and type(amount) == "number",
        "invalid argument for Inventory:addItem")

    if self.items[name] == nil then
        self.items[name] = {
            name = name,
            amount = amount
        }
    else
        self.items[kind].amount = self.items[kind].amount + amount
    end
    return true
end

function Inventory:addToDict(name, data)
    if type(name) == "string" then
        self.itemDict[name] = data
    elseif type(name) == "table" then
        local dict = kind
        for k, v in pairs(dict) do
            self.itemDict[k] = v
        end
    end
end

function Inventory:removeItem(name, amount)
    if self.items[name] == nil then
        return false
    else
        if self.items[name].amount < amount then return false end
        self.items[name].amount = self.items[name].amount - amount
        return true
    end
end

return Inventory
