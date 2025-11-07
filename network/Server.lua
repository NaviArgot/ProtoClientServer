local enet = require "enet"
local json = require "modules.json"
local GameMsg = require "game.Messages"
local NetMsg = require "protocol.Messages"
local Sessions = require "network.Sessions"

local channels = 15

local function start (self)
    self.host = enet.host_create("localhost:9789", 256, channels + 1)
    self.messageQueue:push("Server started")
end

local dirTable = {
    {dx = 0, dy = -1}, -- Up
    {dx = 0, dy = 1}, -- Down
    {dx = -1, dy = 0}, -- Left
    {dx = 1, dy = 0}, -- Right
}

local function joinGame (self, data, peer)
    local id = self.sessions:register(data.userId, peer)
    local msg = GameMsg.execute.newPlayer(id, data.name, data.hue)
    self.actionsQueue:push(msg)
end

local function queueAction (self, playerId, action)
    if not playerId then return end
    -- In the server side Actions received from clients are queued to be executed
    local msg
    if action.type == "MOVE" then
        local dir = dirTable[action.direction] or {dx = 0, dy = 0}
        msg = GameMsg.execute.move(playerId, dir.dx, dir.dy)
    end
    self.actionsQueue:push(msg)
end

local function queryState (self, userId)
    local msg = GameMsg.execute.state(userId)
    self.actionsQueue:push(msg)
end

local function listen (self)
    --print("SENT: ", self.host:total_sent_data())
    --print("RECEIVED: ", self.host:total_received_data())
    local event = self.host:service()
    while event do
        if event.type == "receive" then
            self.messageQueue:push("From: <"..tostring(event.peer).."> Got message: "..tostring(event.data))
            local data = json.decode(tostring(event.data))
            if data.type == "ACTION" then
                local user = self.sessions.users[data.userId]
                local playerId = user and user.playerId or nil
                queueAction(self, playerId, data.data)
            elseif data.type == "JOIN" then joinGame(self, data, event.peer)
            elseif data.type == "GETSTATE" then queryState(self, data.userId) end
        elseif event.type == "connect" then
            self.messageQueue:push("From: <"..tostring(event.peer).."> Got message: connected")
        elseif event.type == "disconnect" then
            self.messageQueue:push("From: <"..tostring(event.peer).."> Got message: disconnected")
        end
        event = self.host:service()
    end
end

local function emit (self)
    -- Sends messages to specific clients
    local serverMsg = self.serverQueue:pop()
    while serverMsg do
        if serverMsg.type == "JOINED" then
            self.sessions:setPlayerId(
                serverMsg.userId,
                serverMsg.playerId
            )
            self.sessions.users[serverMsg.userId].peer:send(
                json.encode(
                    NetMsg.server.joined(serverMsg.userId, serverMsg.playerId)
                )
            )
        elseif serverMsg.type == "STATE" then
            self.sessions.users[serverMsg.userId].peer:send(
                json.encode(
                    NetMsg.server.state(serverMsg.state)
                )
            )
        end
        serverMsg = self.serverQueue:pop()
    end
    -- In the server side Responses are broadcasted to clients
    local res = self.responsesQueue:pop()
    local chan = 1
    while res do
        self.host:broadcast(
            json.encode(NetMsg.server.response(res)),
            chan,
            "unreliable"
        )
        chan = 1 + (chan + 1) % channels
        res = self.responsesQueue:pop()
    end
end

local function close (self)
    self.host:flush()
end

local function create (messageQueue, actionsQueue, responsesQueue, serverQueue)
    local inst = {}
    inst.start = start
    inst.listen = listen
    inst.emit = emit
    inst.close = close
    inst.messageQueue = messageQueue
    inst.actionsQueue = actionsQueue
    inst.responsesQueue = responsesQueue
    inst.serverQueue = serverQueue
    inst.sessions = Sessions.create()
    return inst
end


local module = {
    create = create
}
return module