co = require 'co'
stream = require 'stream'
Parser = require('csv').parse
req = require 'supertest'

token = null

getToken = -> co ->
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

create = (data) ->
  req sails.hooks.http.app
    .post '/api/portfolio'
    .set 'Authorization', "Bearer #{token}"
    .set 'Content-Type', 'application/json'
    .send data

class CSV extends stream.Transform
  constructor: (opts) ->
    super opts
    @tag = opts.tag

  _transform: (chunk, encoding, cb) ->
    fields = [
      'Symbol'
      'Name'
      'Type'
      'Date'
      'Shares'
      'Price'
      'Comission'
      'Notes'
    ]
    data =
      symbol: chunk['Symbol']
      name: chunk['Name']
      type: chunk['Type']
      date: new Date chunk['Date']
      quantity: chunk['Shares']
      price: chunk['Price']
      notes: chunk['Notes']
      tags: [@tag]
    create data
      .then ->
        cb()
      .catch cb

lift = ->
  fs = require 'fs'
  config = JSON.parse fs.readFileSync './.sailsrc'
  require 'bluebird'
    .promisifyAll require 'sails'
    .liftAsync config
  
convert = (tag) ->
  new Promise (resolve, reject) ->
    process.stdin
      .on 'error', reject
      .on 'end', resolve
      .pipe new Parser columns: true
      .on 'error', reject
      .pipe new CSV
        tag: tag
        readableObjectMode: true
        writableObjectMode: true
      .on 'error', reject

tag = process.argv[2]

lift()
  .then getToken
  .then ->
    convert tag
  .catch console.error
