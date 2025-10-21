local update = {}
local protoPlayer = require "game.Player"


function update.NEWPLAYER (gamestate, params)
    local player = protoPlayer.create(
        params.x, params.y, params.hue
    )
    gamestate.players[params.id] = player
end

function update.MOVE (gamestate, params)
    local player = gamestate.players[params.id]
    player.x = params.x
    player.y = params.y
end

return update