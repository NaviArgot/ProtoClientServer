local actions = {}

--[[
    Message that encodes the move command.
    1 = Up, 2 = down, 3 = left, 4 = right
    @param direction int
]]
function actions.move (direction)
    return {
        type = "MOVE",
        direction = direction
    }
end

return actions