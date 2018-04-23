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
        tag: @req.params.all().tag || file.filename
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
    sails.models.portfolio
      .create
        symbol: chunk['Symbol']
        name: chunk['Name']
        type: chunk['Type']
        date: new Date chunk['Date']
        quantity: chunk['Shares']
        price: chunk['Price']
        notes: chunk['Notes']
        tags: [@tag]
        createdBy: @user
      .then ->
        cb()
      .catch (err) ->
        msg = "#{err.details}: #{JSON.stringify chunk}"
        sails.log.error msg
        cb msg

module.exports =
  import: (req, res) ->
    front = req.file 'files'
    back = new Receiver req: req
    resolve = ->
      res.ok {}
    reject = (err) ->
      res.negotiate err
      front.destroy()
      back.destroy()
      back.removeListener 'finish', resolve
    front
      .on 'error', reject
      .pipe back
      .on 'error', reject
      .on 'finish', resolve
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
  findHold: (req, res) ->
    sails.models.portfolio
      .findHold util.parseCriteria req
      .then res.ok, res.negotiate
