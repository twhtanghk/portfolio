Model = require 'jsOAuth2/backend/model/model'

class Hsi extends Model
  name: 'hsi'

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
        if topic == "#{process.env.MQTTTOPIC}/hsi"
          try
            msg = JSON.parse msg.toString()
            @model.insert msg
          catch err
            console.error err

module.exports = new Hsi()
