local function push (self, value)
    self.array[self._r] = value
    self._r = self._r + 1
end

local function pop (self)
    if self._r == self._l then return nil end
    local value = self.array[self._l]
    self._l = self._l + 1
    return value
end

local function new ()
    local instance = {
        _l = 0,
        _r = 0,
        array = {}
    }
    instance.new = new
    instance.push = push
    instance.pop = pop
    return instance
end

local module = {
    new = new,
}

return module