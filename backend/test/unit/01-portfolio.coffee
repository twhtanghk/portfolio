req = require 'supertest'

describe 'Portfolio', ->
  token = null

  before ->
    {CLIENT_ID, CLIENT_SECRET, USER_ID, USER_SECRET, TOKEN_URL} = process.env
    require 'superagent'
      .post TOKEN_URL
      .auth process.env.CLIENT_ID, process.env.CLIENT_SECRET
      .set 'Content-Type', 'application/x-www-form-urlencoded'
      .send 
        grant_type: 'password'
        username: process.env.USER_ID
        password: process.env.USER_SECRET
        scope: ''
      .then (res) ->
        token = res.body.access_token
        console.log token
      .catch ({response}) ->
        console.error response.error.text
        throw response.error.text

  it 'list', ->
    req global.server
      .get '/api/portfolio'
      .set 'Authorization', "Bearer #{token}"
      .set 'Content-Type', 'application/json'
      .expect 200
      .then (res) ->
        console.log res.body

  it 'list for tags', ->
    req global.server
      .post '/api/portfolio'
      .set 'X-HTTP-Method-Override', 'GET'
      .set 'Authorization', "Bearer #{token}"
      .set 'Content-Type', 'application/json'
      .send 
        tags: $in: ['IB', 'cheung']
        skip: 1
        limit: 100
        sort:
          symbol: -1
          quantity: 1
      .expect 200
      .then (res) ->
        console.log res.body

  it 'hold', ->
    req global.server
      .get '/api/portfolio/hold'
      .set 'Authorization', "Bearer #{token}"
      .set 'Content-Type', 'application/json'
      .expect 200
      .then (res) ->
        console.log res.body

  it 'hold for specific tags', ->
    req global.server
      .post '/api/portfolio/hold'
      .set 'X-HTTP-Method-Override', 'GET'
      .set 'Authorization', "Bearer #{token}"
      .set 'Content-Type', 'application/json'
      .send 
        tags: $in: ['IB', 'cheung']
        sort:
          symbol: -1
      .expect 200
      .then (res) ->
        console.log res.body

  it 'tags', ->
    req global.server
      .get '/api/portfolio/tags'
      .set 'Authorization', "Bearer #{token}"
      .set 'Content-Type', 'application/json'
      .expect 200
      .then (res) ->
        console.log res.body
