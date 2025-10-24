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
local messageQueue, actionsQueue, responsesQueue, serverQueue
local gameMaster, gameState

function love.load (args)
    messageQueue = queue.new()
    actionsQueue = queue.new()
    responsesQueue = queue.new()
    console = Console.create()
    gameState = GameState.create()

    if args[1] == "--server" then
        love.window.setTitle("SERVER")
        serverQueue = queue.new()
        network = Server.create(
            messageQueue,
            actionsQueue,
            responsesQueue,
            serverQueue
        )
        gameMaster = GameMaster.create(
            "server",
            messageQueue,
            actionsQueue,
            responsesQueue,
            serverQueue,
            gameState
        )
        isServer = true
    else
        love.window.setTitle("CLIENT")
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
            nil,
            gameState
        )
    end
    network:start()
    input = Input.create(actionsQueue)
end

function love.update ()
    network:listen()
    if not isServer then input:receive() end
    --gameState:minco()
    gameMaster:update()
    network:emit()
    local val = messageQueue:pop()
    while val do
        console:add(val)
        val = messageQueue:pop()
    end
    if love.keyboard.isDown("f5") then network:start() end
    -- Exit love2d
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
end

function love.draw ()
    GameRender.draw(gameState, network.playerId)
    console:draw(15, 15, 15)
end

function love.quit ()
    network:close()
end