assert = require 'assert'

[
  'USER_ID'
  'USER_SECRET'
  'CLIENT_ID'
  'CLIENT_SECRET'
  'TOKEN_URL'
  'VERIFY_URL'
].map (name) ->
  assert name of process.env, "process.env.#{name} not yet defined"

before ->
  global.server = await require '../index'

after ->
  global.server.close()
  process.exit()
    
