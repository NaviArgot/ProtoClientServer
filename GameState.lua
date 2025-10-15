local gamestate = {}

local function newPlayer (self, hue)
    self.playerCount = self.playerCount
    local id = "player_"..self.playerCount
    local x = love.math.random(20)
    local y = love.math.random(20)
    return id, x, y
end

local function move (self, id, dx, dy)
    local player = self.players[id]
    player.x = player.x + dx
    player.y = player.x + dy
    return id, player.x, player.y
end

local actionMap = {
    NEWPLAYER = newPlayer,
    MOVE = move,
}

local function execute (self, action)
    local type = action.action
    local args
    for k, v in pairs(action) do
        if k ~= "action" then args[k] = v end
    end
    return actionMap[type](self, args)
end


function gamestate.create ()
    local inst = {
        playerCount = 0,
        players = {},
        execute = execute,
    }
end

return gamestate