local HSL = require "modules.HSL"

local player = {}

function player.create (x, y, hue)
    hue = hue or love.math.random(255)
    local r, g, b, a = HSL(hue/255, 0.5, 0.5, 1)
    local inst = {
        x = x,
        y = y,
        hue = hue,
        rgb = {r,g,b,a}
    }
    return inst
end

return player
