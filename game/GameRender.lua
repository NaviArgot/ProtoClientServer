local math = require "math"
local HSL = require "modules.HSL"

local GameRender = {}

local sprite = love.graphics.newImage("foxSprite.png")


local function squarePattern(x, y, size)
    local width, height = love.graphics.getDimensions()
    local cols = math.ceil(width/size)
    local rows = math.ceil(height/size)
    local sx = x - math.floor(cols/2)
    local sy = y - math.floor(rows/2)
    for i = 0, rows, 1 do
        for j = 0, cols, 1 do
            local hue = (sx + i + sy + j)%33 / 32
            love.graphics.setColor(HSL(hue, 0.5, 0.3, 1))
            love.graphics.rectangle(
                "fill",
                (j * size) - math.floor(size/2),
                (i * size) - math.floor(size/2), 
                size, size
            )
            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.rectangle(
                "line",
                (j * size) - math.floor(size/2),
                (i * size) - math.floor(size/2), 
                size, size
            )
        end
    end
end

function GameRender.draw (gamestate, playerId)
    local x, y = 0, 0
    local width, height = love.graphics.getDimensions()
    if playerId and gamestate.players[playerId] then
        x = gamestate.players[playerId].x
        y = gamestate.players[playerId].y
    end
    squarePattern(x, y, 32)
    for id, player in pairs(gamestate.players) do
        local graphX = ((player.x-x) * 32) + math.floor(width/2)
        local graphY = ((player.y-y) * 32) + math.floor(height/2)
        love.graphics.setColor(player.rgb)
        love.graphics.draw(sprite, graphX, graphY, nil, 2, 2)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

return GameRender