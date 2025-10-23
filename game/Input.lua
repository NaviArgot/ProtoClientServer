local Actions = require("protocol.Actions")

local Input = {}

local function receive (self)
    local dir = 0
    if love.keyboard.isDown("w", "up") then dir = 1 end
    if love.keyboard.isDown("s", "down") then dir = 2 end
    if love.keyboard.isDown("a", "left") then dir = 3 end
    if love.keyboard.isDown("d", "right") then dir = 4 end
    if dir ~= 0 then
        self.actionsQueue:push(
            Actions.move(dir)
        )
    end
end

function Input.create (actionsQueue)
    local inst = {}
    inst.actionsQueue = actionsQueue
    inst.receive = receive
    return inst
end

return Input