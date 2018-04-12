util = require 'sails/lib/hooks/blueprints/actionUtil'
Promise = require 'bluebird'
stream = require 'stream'
Parser = require('csv').parse

class Receiver extends stream.Writable
  constructor: (opts) ->
    super objectMode: true
    @req = opts.req

  _write: (file, encoding, cb) ->
    file
      .pipe new Parser columns: true
      .on 'error', cb
      .pipe new CSV
        tag: @req.params.all().tag
        user: @req.user
        objectMode: true
      .on 'error', cb
      .on 'finish', cb

class CSV extends stream.Writable
  constructor: (opts) ->
    super opts
    @tag = opts.tag
    @user = opts.user

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
    sails.models.portfolio
      .create _.extend data, createdBy: @user
      .then ->
        cb()
      .catch cb

module.exports =
  import: (req, res) ->
    req
      .file 'file'
      .on 'error', res.negotiate
      .pipe new Receiver req: req
      .on 'error', res.negotiate
      .on 'finish', res.created
  count: (req, res) ->
    sails.models.portfolio
      .count createdBy: req.user.email
      .then (count) ->
        res.ok count: count
      .catch res.negotiate
  tags: (req, res) ->
    sails.models.portfolio
      .find createdBy: req.user.email
      .then (items) ->
        ret = []
        for i in items
          for tag in i.tags
            if tag not in ret
              ret.push tag
        res.ok ret
      .catch res.negotiate
  findOnHold: (req, res) ->
    sails.models.portfolio
      .findOnHold util.parseCriteria req
      .then res.ok, res.negotiate
