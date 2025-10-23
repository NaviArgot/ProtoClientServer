local messages = {}
messages.execute = {}
messages.update = {}
messages.server = {}

function messages.execute.newPlayer (userId, name, hue)
    return {
        type = "NEWPLAYER",
        userId = userId,
        name = name,
        hue = hue,
    }
end

function messages.execute.state (userId)
    return {
        type = "STATE",
        userId = userId,
    }
end

function messages.execute.move (id, dx, dy)
    return {
        type = "MOVE",
        id = id,
        dx = dx,
        dy = dy,
    }
end

function messages.update.newPlayer (id, x, y, hue)
    return {
        type = "NEWPLAYER",
        id = id,
        x = x,
        y = y,
        hue = hue,
    }
end

function messages.update.move (id, x, y)
    return {
        type = "MOVE",
        id = id,
        x = x,
        y = y,
    }
end

function messages.server.joined (userId, playerId)
    return {
        type = "JOINED",
        userId = userId,
        playerId = playerId,
    }
end

function messages.server.state (userId, state)
    return {
        type = "STATE",
        userId = userId,
        state = state,
    }
end

return messages