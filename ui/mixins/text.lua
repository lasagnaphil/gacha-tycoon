local Text = {
    setText = function(self, text, align)
        self.text = text
        self.align = align or "center"
        return self
    end,
    setFont = function(self, font, color)
        self.font = font
        self.fontColor = color or {255, 255, 255, 255}
        return self
    end
}

return Text
