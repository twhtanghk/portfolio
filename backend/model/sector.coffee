_ = require 'lodash'
Promise = require 'bluebird'
{service} = require 'hkex'
Model = require 'koamodel'

name = (url) ->
  code = url.match /.*=([0-9]*)/
  ret = 'hsi'
  if code?
    ret = await service.name code[1]
  return ret

class Sector extends Model
  name: 'sector'

  attributes: [
    'symbol'
    'price'
    'change'
    'changePercent'
    'volume'
  ]

  constructor: ->
    super()
    client = require 'mqtt'
      .connect process.env.MQTTURL,
        username: process.env.MQTTUSER
        clientId: process.env.MQTTCLIENT
        clean: false
      .on 'connect', ->
        client.subscribe "#{process.env.MQTTTOPIC}/#", qos: 2
        console.debug 'mqtt connected'
      .on 'message', (topic, msg) =>
        if topic == "#{process.env.MQTTTOPIC}/sector"
          try
            msg = JSON.parse msg.toString()
            @model.insert msg
          catch err
            console.error err

  find: (ctx, next) ->
    ctx.response.body = await Promise.all (await @sectors())
      .map (sector) =>
        # derive ad from existing data [{date, up, down, diff}, ....]
        sum = 0
        data = (await @adData sector.url).map (row) ->
          sum += row.diff
          _.extend row, ad: sum
        _.extend sector, data: data
    await next()

  ad: (ctx, next) ->
    sector = ctx.params.sector
    ctx.response.body = await @adData sector
    await next()

  # get existing sectors url and name from db
  sectors: ->
    await Promise.all (await @model.distinct 'sector')
      .map (url) ->
        url: url
        name: await name url

  # get sector data [{date, up, down, diff}, ...] from db
  adData: (sector) ->
    await @model.aggregate [
      {
        $match:
          sector: sector
      }
      {
        $group: 
          _id: 
            $dateToString: 
              format: "%Y%m%d"
              date: "$createdAt"
          up: 
            $sum: $cond: [ $gte: ["$change", 0], 1, 0 ]
          down: 
             $sum: $cond: [ $lt: ["$change", 0], 1, 0 ]
      }
      {
        $addFields:
          diff:
            $subtract: [ "$up", "$down" ]
      }
      {
        $sort:
          _id: 1
      }
    ]

module.exports = new Sector()
