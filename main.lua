local Server = require("network.Server")
local Client = require("network.Client")
local queue = require("modules.queue")
local Console = require('modules.Console')
local GameMaster = require("game.GameMaster")
local GameState = require("game.GameState")
local GameRender = require("game.GameRender")
local Input = require("game.Input")

local isServer
local isConsoleVisible = true
local console, input
local network
local messageQueue, actionsQueue, responsesQueue
local gameMaster, gameState

function love.load (args)
    messageQueue = queue.new()
    actionsQueue = queue.new()
    responsesQueue = queue.new()
    console = Console.create()
    gameState = GameState.create()

    if args[1] == "--server" then
        network = Server.create(
            messageQueue,
            actionsQueue,
            responsesQueue
        )
        gameMaster = GameMaster.create(
            "server",
            messageQueue,
            actionsQueue,
            responsesQueue,
            gameState
        )
        isServer = true
    else 
        network = Client.create(
            messageQueue,
            actionsQueue,
            responsesQueue
        )
        gameMaster = GameMaster.create(
            "client",
            messageQueue,
            actionsQueue,
            responsesQueue,
            gameState
        )
    end
    network:start()

    local id = gameMaster:tempCreatePlayer(love.math.random(255))
    input = Input.create(actionsQueue, id)
end

function love.update ()
    network:listen()
    input:receive()
    --gameState:minco()
    gameMaster:update()
    local val = messageQueue:pop()
    while val do
        console:add(val)
        val = messageQueue:pop()
    end
    -- Exit love2d
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
end

function love.draw ()
    GameRender.draw(gameState)
    console:draw(15, 15, 15)
end

function love.quit ()
    network:close()
end