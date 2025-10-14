local Server = require("Server")
local Client = require("Client")
local GlobalQueue = require("GlobalQueue")
local Console = require('Console')

local isConsoleVisible = true
local console = Console.create()
local network

function love.load (args)
    print("")
    print("-1 % 10 = ", -1 % 10)
    print(" 9 % 10 = ",  9 % 10)
    if args[1] == "--server" then network = Server.create()
    else network = Client.create() end
    network:start()
end

function love.update ()
    network:listen()
    local val = GlobalQueue:pop()
    while val do
        console:add(val)
        val = GlobalQueue:pop()
    end
    if love.keyboard.isDown("escape") then
        network:close()
        love.event.quit()
    end
end

function love.draw ()
    console:draw(15, 15, 15)
end