Q       = require 'q'

###
Used for post comit hooks on github
###

module.exports = class Github

  constructor: (@output) ->

  process: (req) ->
    d = Q.defer()
    try
      payload = JSON.parse(req.body.payload)

      branch = (payload.ref.split("/").pop())
      sentance = "#{payload.pusher.name} pushed to #{branch} on #{payload.repository.name}."+
      " With message; #{payload.head_commit.message}"
      d.resolve(@output.speak(sentance))

    catch e
      d.reject new Error("Message malformed")
    
   
    #@output.speak(req.body.tts)
    return d.promise