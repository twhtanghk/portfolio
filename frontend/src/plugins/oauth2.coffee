_ = require 'lodash'
{format, parse} = require 'url'
token = null

github =
  authorization: ({url, client_id}={}) ->
    url ?= process.env.AUTH_URL
    client_id ?= process.env.CLIENT_ID
    url = parse url
    url = _.extend url,
      query:
        client_id: client_id
        response_type: 'code'
    window.location.replace format url

  token: ({url, client={}, code}) ->
    url ?= process.env.TOKEN_URL
    client['id'] ?= process.env.CLIENT_ID
    client['secret'] ?= process.env.CLIENT_SECRET
    res = await fetch url,
      method: 'post'
      headers:
        "Content-type": "application/x-www-form-urlencoded"
      body: "client_id=#{client['id']}&client_secret=#{client['secret']}&code=#{code}"
    res = await res.json()    
    res.access_token

{query} = parse window.location.href, true
if query['code']?
  token = github.token code: query['code']

export default fetch: (url, opts={}) ->
  if token?
    opts = _.defaultsDeep opts,
      headers:
        Authorization: "Bearer #{token}"
  res = await fetch url, opts
  if res.status == 401
    github.authorization()
  res
