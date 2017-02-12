local Stack = class("Stack")

function Stack:initialize(elems)
    self.elems = elems or {}
end

function Stack:push(elem)
    self.elems[#self.elems + 1] = elem
end

function Stack:pop()
    self.elems[#self.elems] = nil
end

function Stack:peek()
    return self.elems[#self.elems]
end

function Stack:clear()
    self.elems = {}
end

return Stack
