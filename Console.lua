local function add (self, text)
    self.entries[self.final] = text
    self.final = (self.final + 1) % self.maxlines
    self.total = self.total < self.maxlines and (self.total + 1) or self.maxlines
end

local function draw(self, x, y, size)
    for count = 1, self.total, 1 do
        local i = (self.final - count) % self.maxlines
        local value = self.entries[i]
        local posy = y + count * size
        love.graphics.print(value, x, posy)
    end
end

local function create (maxlines)
    local _maxlines = maxlines or 500
    return {
        entries = {},
        final = 0,
        total = 0,
        maxlines = _maxlines,
        add = add,
        draw = draw,
    }
end

local module = {
    create = create,
}
Console = module
return Console