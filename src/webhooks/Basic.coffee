###
Simple hook that use post param tts to send text
###

module.exports = class Basic

  constructor: (@output) ->

  process: (req) ->
    @output.speak(req.body.tts)