local BindVar = {
    initialize = function(self)
        self.bindings = {}
    end,
    bindVar = function(self, varName, getter)
        self.bindings[varName] = getter
        return self
    end,
    updateBindings = function(self)
        for name, getter in pairs(self.bindings) do
            self[name] = self.bindings[name]()
        end
    end
}

return BindVar
