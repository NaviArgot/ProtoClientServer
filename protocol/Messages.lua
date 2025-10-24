local messages = {}
messages.client = {}
messages.server = {}

function messages.client.action(userId, action)
    return {
        type = 'ACTION',
        userId = userId,
        data = action,
    }
end

function messages.client.join (name, hue)
    return {
        type = "JOIN",
        name = name,
        hue = hue,
    }
end

function messages.client.getState (userId)
    return {
        type = "GETSTATE",
        userId = userId,
    }
end


function messages.server.response (response)
    return {
        type = 'RESPONSE',
        data = response,
    }
end



function messages.server.joined (userId)
    return {
        type = "JOINED",
        userId = userId,
    }
end



function messages.server.state (state)
    return {
        type = "STATE",
        data = state,
    }
end

return messages