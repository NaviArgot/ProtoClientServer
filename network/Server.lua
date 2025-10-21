local enet = require "enet"
local json = require "modules.json"

local function start (self)
    self.host = enet.host_create("localhost:9789")
    self.messageQueue:push("Server started")
end

local function queueAction(self, data)
    -- In the server side Actions received from clients are queued to be executed
    if data.type == 'action' then self.actionsQueue:push(data) end
end

local function joinGame (event)
    
end

local endpoints = {
    "JOIN"
}

local function listen (self)
    local event = self.host:service(100)
    while event do
        if event.type == "receive" then
            local data = json.decode(tostring(event.data))
            self.messageQueue:push("From: <"..tostring(event.peer).."> Got message: "..tostring(event.data))
        elseif event.type == "connect" then
            self.messageQueue:push("From: <"..tostring(event.peer).."> Got message: connected")
        elseif event.type == "disconnect" then
            self.messageQueue:push("From: <"..tostring(event.peer).."> Got message: disconnected")
        end
        event = self.host:service()
    end
end

local function emit (self)
    -- In the server side Responses are broadcasted to clients
    local data = self.responsesQueue:pop()
    while data do
       self.host:emit(json.encode(data))
    end
end

local function close (self)
    self.host:flush()
end

local function create (messageQueue, actionsQueue, responsesQueue)
    local inst = {}
    inst.start = start
    inst.listen = listen
    inst.emit = emit
    inst.close = close
    inst.messageQueue = messageQueue
    inst.actionsQueue = actionsQueue
    inst.responsesQueue = responsesQueue
    inst.sessions = {} -- sessionId -> enet::peer
    return inst
end


local module = {
    create = create
}
return module