local queue = require("queue")

return {
    messageQueue = queue.new(),
    actionsQueue = queue.new(),
    responsesQueue = queue.new(),
}