local GameRender = {}

local sprite = love.graphics.newImage("foxSprite.png")

function GameRender.draw (gamestate)
    
    for id, player in pairs(gamestate.players) do
        love.graphics.setColor(player.rgb)
        love.graphics.draw(sprite, player.x, player.y)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

return GameRender