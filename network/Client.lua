local enet = require "enet"
local json = require "modules.json"
local NetMsg = require "protocol.Messages"

local names = {
    "Mariano", "Plink", "Ovoyo", "Chamans", "Aeberb",
    "Cjier", "Furini", "Toretelei", "Amagu", "Zoheru",
    "Ranqw", "Chimueb",
}

local function start (self)
    self.host = enet.host_create()
    self.server = self.host:connect("localhost:9789")
    self.messageQueue:push("Client started")
end

local function queueResponses(self, res)
    if not self.gotState then return end
    self.responsesQueue:push(res)
end

local function loadState (self, state)
    for i, gameMsg in ipairs(state) do
        self.responsesQueue:push(gameMsg)
    end
    self.gotState = true
end

local function whenJoined ()
    
end

local function listen (self)
    local event = self.host:service(100)
    while event do
        if event.type == "receive" then
            local data = json.decode(tostring(event.data))
            -- In the client side responses received from the server are queued to update the gamestate
            if data.type == "RESPONSE" then queueResponses(self, data.data)
            elseif data.type == "JOINED" then self.userId = data.userId
            elseif data.type == "STATE" then loadState(self, data.data) end
            self.messageQueue:push("From: <"..tostring(event.peer).."> Got message: "..tostring(event.data))
        elseif event.type == "connect" then
            -- Join a game
            self.server:send(
                json.encode(
                    NetMsg.client.join(
                        names[love.math.random(#names)],
                        love.math.random(255)
                    )
                )
            )
            self.isConnected = true
            self.messageQueue:push("From: <"..tostring(event.peer).."> Got message: connected")
        elseif event.type == "disconnect" then
            self.isConnected = false
            self.messageQueue:push("From: <"..tostring(event.peer).."> Got message: disconnected")
        end
        event = self.host:service()
    end
end

local function emit (self)
    -- In the client side actions are sent to the server to be evaluated
    local act = self.actionsQueue:pop()
    while act do
        self.server:send(
            json.encode(
                NetMsg.client.action(self.userId, act)
            )
        )
        act = self.actionsQueue:pop()
    end
end

local function close (self)
    self.server:disconnect()
    self.host:flush()
end

local function create (messageQueue, actionsQueue, responsesQueue)
    local inst = {}
    inst.isConnected = false
    inst.gotState = false
    inst.start = start
    inst.listen = listen
    inst.emit = emit
    inst.close = close
    inst.messageQueue = messageQueue
    inst.actionsQueue = actionsQueue
    inst.responsesQueue = responsesQueue
    return inst
end


Client = {
    create = create,
}
return Client