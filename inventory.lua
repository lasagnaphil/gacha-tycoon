local Inventory = class("Inventory")

function Inventory:initialize()
    self.items = {}
end

function Inventory:addItem(kind, index, data)
    assert(type(kind) == "string" and type(index) == "number" and type(data) == "table",
        "invalid argument for Inventory:addItem")

    self.items[#self.items + 1] = {
        kind = kind,
        index = index,
        data = data
    }
end

return Inventory
