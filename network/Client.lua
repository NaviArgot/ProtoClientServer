local enet = require "enet"
local GQ = require "game.GlobalQueues"
local json = require "modules.json"

local function start (self)
    self.host = enet.host_create()
    self.server = self.host:connect("localhost:9789")
    GQ.messageQueue:push("Client started")
end

local function listen (self)
    local event = self.host:service(100)
    while event do
        if event.type == "receive" then
            local data = json.decode(tostring(event.data))
            -- In the client side responses received from the server are queued to update the gamestate
            if data.response then GQ.responsesQueue:push(data) end
            GQ.messageQueue:push("From: <"..tostring(event.peer).."> Got message: "..tostring(event.data))
        elseif event.type == "connect" then
            GQ.messageQueue:push("From: <"..tostring(event.peer).."> Got message: connected")
        elseif event.type == "disconnect" then
            GQ.messageQueue:push("From: <"..tostring(event.peer).."> Got message: disconnected")
        end
        event = self.host:service()
    end
end

local function emit (self)
    -- In the client side actions are sent to the server to be evaluated
    local data = GQ.actionsQueue:pop()
    while data do
       self.host:emit(json.encode(data))
    end
end

local function close (self)
    self.server:disconnect()
    self.host:flush()
end

local function create ()
    local inst = {}
    inst.start = start
    inst.listen = listen
    inst.close = close
    return inst
end


Client = {
    create = create,
}
return Client