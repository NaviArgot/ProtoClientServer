local function newPlayer (x, y, hue)
    return {
        action = "NEWPLAYER",
        hue = hue,
    }
end


local function move (id, dx, dy)
    return {
        action = "MOVE",
        id = id,
        dx = dx,
        dy = dy,
    }
end