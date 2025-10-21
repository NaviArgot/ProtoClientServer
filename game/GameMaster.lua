local Actions = require "protocol.Actions"
local Responses = require "protocol.Responses"
local gamestate = require "game.GameState"

local function client_update(self)
    --- Received Responses to Actions from server
    local res = self.responsesQueue:pop()
    while res do
        self.gamestate:update(res)
        res = self.responsesQueue:pop()
    end
end


local function server_update (self)
    --- Performs actions received from clients and queues
    --- Responses to send back
    local act = self.actionsQueue:pop()
    while act do
        local res = self.gamestate:execute(act)
        self.responsesQueue:push(res)
        act = self.actionsQueue:pop()
    end
end

local function tempCreatePlayer (self, hue)
    local act = Actions.newPlayer(hue)
    local res = self.gamestate:execute(act)
    return res.id
end


local GameMaster = {}

--[[
    Create a Gamemaster that handles gamestate and input and output
    from client or server.

    @param type string Either "server" or "client".
]]
function GameMaster.create (type, messageQueue, actionsQueue, responsesQueue, gamestate)
    type = type or "client"
    local inst = {}
    inst.type = type
    inst.state = 0
    inst.messageQueue = messageQueue
    inst.actionsQueue = actionsQueue
    inst.responsesQueue = responsesQueue
    inst.gamestate = gamestate
    inst.update = type == "server" and server_update or client_update
    inst.tempCreatePlayer = tempCreatePlayer
    return inst
end

return GameMaster