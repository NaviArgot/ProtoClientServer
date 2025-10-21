local responses = {}

function responses.newPlayer (id, x, y, hue)
    return {
        type = "NEWPLAYER",
        id = id,
        x = x,
        y = y,
        hue = hue,
    }
end

function responses.move (id, x, y)
    return {
        type = "MOVE",
        id = id,
        x = x,
        y = y,
    }
end

return responses