co = require 'co'
passport = require 'koa-passport'
{Strategy} = require 'passport-http-bearer'

verify = ({url, scope, token}) ->
  url ?= process.env.VERIFY_URL
  scope ?= []
  {statusCode, statusMessage, body} = await require 'needle'
    .get url, headers: Authroization: "Bearer #{token}"
  assert res.statusCode == 200, "#{statusMessage}: #{if body instanceof Buffer t
hen body.toString() else util.inspect body}"
  result = _.intersection scope, res.body.scope.split ' '
  assert result.length == scope.length, "Unauthorized access to #{scope}"
  res.body

passport.use new Strategy (token, done) -> co ->
  try
    res = await verify {token}
    done null, _.extend res.user, client: res.client_id
  catch err
    done err, false

module.export = passport
