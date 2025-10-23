local updateMod = require "game.Update"
local executeMod = require "game.Execute"

local gamestate = {}

local function oblivion(self, ...)
    local args = {...}
    self.messageQueue:push("RECEIVED WRONG MESSAGE WITH: "..tostring(args))
end

local function execute (self, action, serverQueue)
    return (executeMod[action.type] or oblivion)(self, action, serverQueue);
end

local function update (self, response)
    return (updateMod[response.type] or oblivion)(self, response);
end

local function minco (self)
    print("-------- GAMESTATE ---------")
    print("Player count: ", self.playerCount)
    for k, v in pairs(self.players) do print(k, v) end
end


function gamestate.create (serverQueue)
    local inst = {
        playerCount = 0,
        players = {},
        execute = execute,
        update = update,
        minco = minco,
    }
    return inst
end

return gamestate