local function newPlayer (id, x, y, hue)
    return {
        response = "NEWPLAYER",
        id = id,
        x = x,
        y = y,
        hue = hue,
    }
end

local function move (id, x, y)
    return {
        action = "MOVE",
        id = id,
        x = x,
        y = y,
    }
end