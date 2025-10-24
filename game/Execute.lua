local execute = {}
local msg = require "game.Messages"
local protoPlayer = require "game.Player"


function execute.NEWPLAYER (gamestate, params, serverQueue)
    gamestate.playerCount = gamestate.playerCount + 1
    local id = "player_"..gamestate.playerCount
    local x = love.math.random(20)
    local y = love.math.random(20)
    local hue = params.hue
    gamestate.players[id] = protoPlayer.create(x, y, hue)
    --- Sends message to reply back to the client with it's playerId
    serverQueue:push(msg.server.joined(params.userId, id))
    return msg.update.newPlayer(id, x, y, hue)
end

function execute.STATE (gamestate, params, serverQueue)
    local state = {}
    for id, player in pairs(gamestate.players) do
        state[#state + 1] = msg.update.newPlayer(id, player.x, player.y, player.hue)
    end
    serverQueue:push(msg.server.state(params.userId, state))
end

function execute.MOVE (gamestate, params)
    local player = gamestate.players[params.id]
    player.x = player.x + params.dx
    player.y = player.y + params.dy
    return msg.update.move(params.id, player.x, player.y)
end

return execute