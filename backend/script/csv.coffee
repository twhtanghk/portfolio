co = require 'co'
stream = require 'stream'
Parser = require('csv').parse
req = require 'supertest'
Promise = require 'bluebird'
Sails = Promise.promisifyAll require 'sails'

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

class CSV extends stream.Writable
  constructor: (opts) ->
    super opts
    @tag = opts.tag

  _write: (chunk, encoding, cb) ->
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
  Sails.liftAsync config
  
convert = (tag) ->
  new Promise (resolve, reject) ->
    process.stdin
      .on 'error', reject
      .pipe new Parser columns: true
      .on 'error', reject
      .pipe new CSV
        tag: tag
        objectMode: true
      .on 'error', reject
      .on 'finish', resolve

tag = process.argv[2]

lift()
  .then getToken
  .then ->
    convert tag
  .then ->
    Sails.lowerAsync()
  .catch console.error
