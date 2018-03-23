req = require 'supertest'
co = require 'co'

describe 'Portfolio Controller', ->
  id = null
  token = null

  before -> co ->
    {CLIENT_ID, CLIENT_SECRET, USER_ID, USER_SECRET} = process.env
    opts =
      url: sails.config.oauth2.url
      grant_type: 'password'
      client:
        id: CLIENT_ID
        secret: CLIENT_SECRET
      user:
        id: USER_ID
        secret: USER_SECRET
      scope: ['User']
    token = yield sails.config.oauth2.getToken opts

  it 'create', ->
    req sails.hooks.http.app
      .post '/api/portfolio'
      .set 'Authorization', "Bearer #{token}"
      .set 'Content-Type', 'application/json'
      .send
        symbol: '1132'
        name: 'orange sky'
        type: 'Buy'
        quantity: 1000
        price: 0.63
      .expect 201
      .then (res) ->
        id = res.body.id

  it 'list', ->
    req sails.hooks.http.app
      .get '/api/portfolio'
      .set 'Authorization', "Bearer #{token}"
      .set 'Content-Type', 'application/json'
      .expect 200

  it 'count', ->
    req sails.hooks.http.app
      .get '/api/portfolio/count'
      .set 'Authorization', "Bearer #{token}"
      .set 'Content-Type', 'application/json'
      .expect 200

  it 'update', ->
    req sails.hooks.http.app
      .put "/api/portfolio/#{id}"
      .set 'Authorization', "Bearer #{token}"
      .set 'Content-Type', 'application/json'
      .send
        price: 0.55
      .expect 200

  it 'delete', ->
    req sails.hooks.http.app
      .delete "/api/portfolio/#{id}"
      .set 'Authorization', "Bearer #{token}"
      .set 'Content-Type', 'application/json'
      .expect 200

  it 'tags', ->
    req sails.hooks.http.app
      .get '/api/portfolio/tags'
      .set 'Authorization', "Bearer #{token}"
      .set 'Content-Type', 'application/json'
      .expect 200
