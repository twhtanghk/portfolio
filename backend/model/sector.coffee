Model = require 'koamodel'

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

  ad: (ctx, next) ->
    sector = ctx.params.sector
    ctx.response.body = await @model.aggregate [
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
