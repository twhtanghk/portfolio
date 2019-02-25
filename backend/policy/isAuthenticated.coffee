_ = require 'lodash'
co = require 'co'
passport = require 'passport'
{Strategy} = require 'passport-http-bearer'

verify = ({url, scope, token}) ->
  url ?= process.env.VERIFY_URL
  scope ?= []
  {statusCode, statusMessage, body} = await require 'needle'
    .get url, headers: Authroization: "Bearer #{token}"
  assert res.statusCode == 200, "#{statusMessage}: #{if body instanceof Buffer then body.toString() else util.inspect body}"
  result = _.intersection scope, res.body.scope.split ' '
  assert result.length == scope.length, "Unauthorized access to #{scope}"
  res.body

passport.use 'bearer', new Strategy (token, done) -> co ->
  try
    res = await verify {token}
    done null, _.extend res.user, client: res.client_id
  catch err
    done err, false
  
module.exports = (ctx, next) ->
  mw = passport.authenticate 'bearer', session: false
  mw ctx.request, ctx.response, (err) -> co ->
    if err?
      return ctx.throw 500, err
    await next()
