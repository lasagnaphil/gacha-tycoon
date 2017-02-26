local Image = require "ui.image"
local MInteractive = require "ui.mixins.interactive"

local ClickableImage = class("ClickableImage", Image)
ClickableImage:include(MInteractive)

function ClickableImage:initialize(posX, posY, pivotX, pivotY, width, height, sprite)
    Image.initialize(self, posX, posY, pivotX, pivotY, width, height, sprite)
    MInteractive.initialize(self)
end

return ClickableImage
