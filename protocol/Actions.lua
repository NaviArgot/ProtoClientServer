local actions

function actions.newPlayer (x, y, hue)
    return {
        action = "NEWPLAYER",
        hue = hue,
    }
end

function actions.move (id, dx, dy)
    return {
        action = "MOVE",
        id = id,
        dx = dx,
        dy = dy,
    }
end

return actions