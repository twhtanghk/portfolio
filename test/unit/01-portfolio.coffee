req = require 'supertest'

describe 'Portfolio Controller', ->
  id = null
  token = null

  it 'create', ->
    req sails.hooks.http.app
      .post '/api/portfolio'
      .set 'Authorization', "Bearer #{token}"
      .send
        symbol: '1132'
        name: 'orange sky'
        type: 'Buy'
        quantity: 1000
        price: 0.63
      .then (res) ->
        id = res.id
      .expect 201

  it 'list', ->
    req sails.hooks.http.app
      .get '/api/portfolio'
      .set 'Authorization', "Bearer #{token}"
      .expect 200

  it 'update', ->
    req sails.hooks.http.app
      .put "/api/portfolio/#{id}"
      .set 'Authorization', "Bearer #{token}"
      .send
        price: 0.55
      .expect 200

  it 'delete', ->
    req sails.hooks.http.app
      .delete "/api/portfolio/#{id}"
      .set 'Authorization', "Bearer #{token}"
      .expect 200
