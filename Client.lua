local enet = require "enet"
local GlobalQueue = require("GlobalQueue")

local function start (self)
    self.host = enet.host_create()
    self.server = self.host:connect("localhost:9789")
    print("Client started")
end

local function listen (self)
    local event = self.host:service(100)
    while event do
        if event.type == "receive" then
            GlobalQueue:push("From: <"..tostring(event.peer).."> Got message: "..tostring(event.data))
            event.peer:send( "ping" )
        elseif event.type == "connect" then
            GlobalQueue:push("From: <"..tostring(event.peer).."> Got message: connected")
            event.peer:send( "ping" )
        elseif event.type == "disconnect" then
            GlobalQueue:push("From: <"..tostring(event.peer).."> Got message: disconnected")
        end
        event = self.host:service()
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