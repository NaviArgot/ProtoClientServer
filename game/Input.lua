local Actions = require("protocol.Actions")

local Input = {}

local function receive (self)
    local dx, dy = 0, 0
    if love.keyboard.isDown("w", "up") then dy = dy - 1 end
    if love.keyboard.isDown("s", "down") then dy = dy + 1 end
    if love.keyboard.isDown("a", "left") then dx = dx - 1 end
    if love.keyboard.isDown("d", "right") then dx = dx + 1 end
    if self.playerId and (dx ~= 0 or dy ~= 0) then
        self.actionsQueue:push(
            Actions.move(self.playerId, dx, dy)
        )
    end
    if love.keyboard.isDown("p") then
        self.actionsQueue:push(
            Actions.newPlayer(love.math.random(255))
        )
    end
end

function Input.create (actionsQueue, playerId)
    local inst = {}
    inst.playerId = playerId
    inst.actionsQueue = actionsQueue
    inst.receive = receive
    return inst
end

return Input