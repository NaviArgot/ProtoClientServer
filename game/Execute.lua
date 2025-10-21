local execute = {}
local responses = require "protocol.Responses"
local protoPlayer = require "game.Player"


function execute.NEWPLAYER (gamestate, params)
    gamestate.playerCount = gamestate.playerCount + 1
    local id = "player_"..gamestate.playerCount
    local x = love.math.random(20)
    local y = love.math.random(20)
    local hue = params.hue
    gamestate.players[id] = protoPlayer.create(x, y, hue)
    return responses.newPlayer(id, x, y, hue)
end

function execute.MOVE (gamestate, params)
    local player = gamestate.players[params.id]
    player.x = player.x + params.dx
    player.y = player.y + params.dy
    return responses.move(params.id, player.x, player.y)
end

return execute