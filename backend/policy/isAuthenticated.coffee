_ = require 'lodash'
co = require 'co'
passport = require 'koa-passport'
{Strategy} = require 'passport-http-bearer'
compose = require 'koa-compose'
assert = require 'assert'
util = require 'util'
Promise = require 'bluebird'
needle = Promise.promisifyAll require 'needle'
user = require '../model/user'

verify = ({url, scope, token}) ->
  url ?= process.env.VERIFY_URL
  scope ?= []
  {statusCode, statusMessage, body} = await needle
    .getAsync url, headers: Authorization: "Bearer #{token}"
  assert statusCode == 200, "#{statusMessage}: #{if body instanceof Buffer then body.toString() else util.inspect body}"
  body

passport.use new Strategy (token, done) -> co ->
  try
    done null, await verify {token}
  catch err
    done err, false

findUser = (ctx, next) ->
  try
    subject = await user.model.findOne _.pick(ctx.req.user, 'email')
    if subject?
      ctx.req.user = subject
    else
      ctx.req.user = await user.model.insert ctx.req.user
    await next()
  catch err
    ctx.throw 500, err.toString()

module.exports =
  compose [
    passport.authenticate 'bearer', session: false
    findUser
    (ctx, next) ->
      if ctx.isAuthenticated()
        return await next()
  ]
