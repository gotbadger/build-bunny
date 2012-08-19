request = require 'request'
qs      = require 'querystring'
Q       = require 'q'

###
 Module to interface with wizz.cc

 see: http://nabaztag.forumactif.fr/t14297-vlt-wizzcc-api-unifiee-pour-les-nabaztag-karotz

###

module.exports = class Wizz
  
  constructor: (@serial,@token,@ws_acapela) ->


  speak:(text,callback) ->
    d = Q.defer()
    #generate request string
    uri = "http://api.wizz.cc/?"
    
    query = qs.stringify(
      'ws_acapela' : @ws_acapela
      'token' : @token
      'sn' : @serial
      'tts' : text
      )

    request.get uri+query, (error, response, body) ->
      if not error and response.statusCode is 200
        if body == "Message vide !"
          d.reject new Error("Message text was empty or malformed")
        else
          d.resolve body
      if not error and response.statusCode is not 200
        d.reject new Error("#{response.statusCode} -> #{response.body}")
      else
        d.reject error

    return d.promise
