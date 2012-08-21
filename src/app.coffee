express = require('express')
port = if process.env.PORT? then process.env.PORT else 3000

#output methods
Wizz      = require('./output/Wizz')
#webhooks
Basic     = require('./webhooks/Basic')
Github    = require('./webhooks/Github')


#check for some envs
checkenv = (varname) ->
  if not process.env[varname]?
    console.log "env var '#{varname}' must be set"
    process.exit(1)

checkenv("serial")
checkenv("token")
checkenv("username")
checkenv("password")

serial = process.env.serial
token = process.env.token

#setup handlers
wizzConnection = new Wizz(serial,token,'Graham')

responders =
  'basic' : new Basic(wizzConnection)
  'github': new Github(wizzConnection)


app = express.createServer();
auth = express.basicAuth process.env.username, process.env.password
app.configure () ->
  app.use express.bodyParser()
  app.use express.methodOverride()

app.get '/',(req, res) ->
  #do 301 to the repo
  res.writeHead(301, {'Location':'https://github.com/gotbadger/build-bunny', 'Expires': (new Date).toGMTString()});
  res.end();

app.post '/hook/:hook',auth,(req, res) ->
  hook = req.params.hook
  if not responders[hook]?
   res.writeHead 404
   res.end "no such hook"
  else
    responders[hook].process(req)
    .then (data) ->
      res.writeHead 200
      res.end data.toString()
    ,(error) ->
      res.writeHead 500
      res.end error.toString()
      console.log error.toString() 
    .end()


app.listen(port);
console.log "build bunny messaging warren started on #{port}"