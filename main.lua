local Server = require("network.Server")
local Client = require("network.Client")
local queue = require("modules.queue")
local Console = require('modules.Console')

local isServer
local isConsoleVisible = true
local console = Console.create()
local network
local messageQueue, actionsQueue, responsesQueue

function love.load (args)
    messageQueue = queue.new()
    actionsQueue = queue.new()
    responsesQueue = queue.new()
    if args[1] == "--server" then
        network = Server.create(
            messageQueue,
            actionsQueue,
            responsesQueue
        )
        isServer = true
    else 
        network = Client.create(
            messageQueue,
            actionsQueue,
            responsesQueue
        )
    end
    network:start()
end

function love.update ()
    network:listen()
    local val = messageQueue:pop()
    while val do
        console:add(val)
        val = messageQueue:pop()
    end
    -- Exit love2d
    if love.keyboard.isDown("escape") then
        network:close()
        love.event.quit()
    end
end

function love.draw ()
    console:draw(15, 15, 15)
end