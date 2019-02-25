Koa = require 'koa'
logger = require 'koa-logger'
bodyParser = require 'koa-bodyparser'
methodOverride = require 'koa-methodoverride'
router = require './router'
serve = require 'koa-static'
cors = require '@koa/cors'
Promise = require 'bluebird'

app = new Koa()
app.context.onerror = require 'koa-better-error-handler'
app.keys = process.env.KEYS?.split(',') || ['keep it secret']
module.exports = new Promise (resolve, reject) ->
  server = app
    .use logger()
    .use require 'koa-404-handler'
    .use bodyParser()
    .use methodOverride()
    .use cors()
    .use router.routes()
    .use router.allowedMethods()
    .use serve 'dist'
    .listen parseInt(process.env.PORT) || 3000, (err) ->
      if err?
        return reject err
      resolve server
