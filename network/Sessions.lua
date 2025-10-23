local count = 0

local function genId ()
    -- TODO: Make a better id generator
    count = count + 1
    return "session_"..count
end

local function setPlayerId(self, userId, playerId)
    if not self.users[userId] then return end
    self.users[userId].playerId = playerId
end

local function register (self, userId, peer)
    local id = genId()
    if userId then
        -- TODO: Check if session is still available
    end
    self.users[id] = {
        peer = peer,
        playerId = "none"
    }
    return id
end

local sessions = {}

function sessions.create()
    local inst = {}
    inst.users = {}
    inst.register = register
    inst.setPlayerId = setPlayerId
    return inst
end

return sessions