local enet = require "enet"
local json = require "modules.json"

local function start (self)
    self.host = enet.host_create()
    self.server = self.host:connect("localhost:9789")
    self.messageQueue:push("Client started")
end

local function listen (self)
    local event = self.host:service(100)
    while event do
        if event.type == "receive" then
            local data = json.decode(tostring(event.data))
            -- In the client side responses received from the server are queued to update the gamestate
            if data.type == 'response' then self.responsesQueue:push(data.data) end
            self.messageQueue:push("From: <"..tostring(event.peer).."> Got message: "..tostring(event.data))
        elseif event.type == "connect" then
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
    local data = self.actionsQueue:pop()
    while data do
       self.host:emit(json.encode(data))
    end
end

local function close (self)
    self.server:disconnect()
    self.host:flush()
end

local function create (messageQueue, actionsQueue, responsesQueue)
    local inst = {}
    inst.isConnected = false
    inst.start = start
    inst.listen = listen
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