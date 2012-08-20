Q       = require 'q'

###
Used for post comit hooks on github
###

module.exports = class Github

  constructor: (@output,@ref) ->

  process: (req) ->
    d = Q.defer()
    try
      payload = JSON.parse(req.body.payload)
      if payload.ref == @ref
        sentance = "#{payload.pusher.name} pushed to master on #{payload.repository.name}."+
        " With message; #{payload.head_commit.message}"
        d.resolve(@output.speak(sentance))
      else
        d.resolve("I do not monitor this branch")
    catch e
      d.reject new Error("Message malformed")
    
   
    #@output.speak(req.body.tts)
    return d.promise