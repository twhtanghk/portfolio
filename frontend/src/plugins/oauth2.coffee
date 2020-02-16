_ = require 'lodash'
{format, parse} = require 'url'
token = null

export default fetch: (url, opts={}) ->
  if token?
    opts = _.defaultsDeep opts,
      headers:
        Authorization: "Bearer #{token}"
  res = await fetch url, opts
  if res.status == 401
    auth_url = parse process.env.AUTH_URL
    auth_url = _.extend auth_url,
      query:
        client_id: process.env.CLIENT_ID
        response_type: 'code'
    windows.location.replace format auth_url,
  res
