local HSL = require "HSL"

local function update (self)
    local dx, dy = 0, 0
    if love.keyboard.isDown("w") then dy = dy - 1 end
    if love.keyboard.isDown("s") then dy = dy + 1 end
    if love.keyboard.isDown("a") then dx = dx + 1 end
    if love.keyboard.isDown("d") then dx = dx - 1 end
    self.x = self.x + dx
    self.y = self.y + dy
end

local function draw (self)
    love.graphics.draw(self.sprite, self.x * 16, self.y * 16)
end

local function create (x, y, hue)
    local inst = {
        x = x,
        y = y,
        sprite = love.graphics.newImage('foxSprite.png'),
        rgb = HSL(love.math.random(), 0.5, 0.5, 1)
    }
    inst.update = update
    inst.draw = draw

end

