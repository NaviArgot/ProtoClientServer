local queue = require("modules.queue")

return {
    messageQueue = queue.new(),
    actionsQueue = queue.new(),
    responsesQueue = queue.new(),
}