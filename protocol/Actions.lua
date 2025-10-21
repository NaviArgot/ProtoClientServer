local actions = {}

function actions.newPlayer (hue)
    return {
        type = "NEWPLAYER",
        hue = hue,
    }
end

function actions.move (id, dx, dy)
    return {
        type = "MOVE",
        id = id,
        dx = dx,
        dy = dy,
    }
end

return actions