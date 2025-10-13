local function add (self, text)
    local i = #self.entries + 1
    self.entries[i] = text
end

local function draw(self, x, y, size)
    for i = #self.entries, 1, -1 do
        local value = self.entries[i]
        local posy = y + (#self.entries - i) * size
        love.graphics.print(value, x, posy)
    end
end

local function create ()
    return {
        entries = {},
        add = add,
        draw = draw,
    }
end

local module = {
    create = create,
}
Console = module
return Console