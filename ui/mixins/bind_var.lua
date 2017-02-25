local BindVar = {
    initialize = function(self)
        self.bindings = {}
    end,
    bindVar = function(self, varName, getter, setter)
        self.bindings[varName] = {getter = getter, setter = setter}
        return self
    end,
    updateBindings = function(self)
        for name, binding in pairs(self.bindings) do
            if binding.setter then
                binding.setter(self, binding.getter())
            else
                self[name] = binding.getter()
            end
        end
    end
}

return BindVar
