local messages = {}

function messages.action(action)
    return {
        type = 'action',
        data = action,
    }
end


function messages.response(response)
    return {
        type = 'response',
        data = response,
    }
end

--[[
    Client must send ths message to join a game.
    
    @param sessionId string|nil 
    If the client needs to reconnect you should send the saved sessionId
]]
function messages.join(sessionId)
    return {
        type = "JOIN",
        sessionId = sessionId,
    }
end


--[[
    Server sends joined message to inform the client it has joined
    a game. Also includes a sessionId which is used to uniquely 
    identify the client.
    @param sessionId string Uniquely identifies the client for the
    current session
]]
function messages.joined(sessionId)
    return {
        type = "JOINED",
        sessionId = sessionId,
    }
end

return messages