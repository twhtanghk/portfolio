<script lang='coffee'>
guid = require 'browserguid'
store = require 'mqtt-level-store'
{incoming, outgoing} = store 'db'
mqtt = require 'mqtt'
client = mqtt
  .connect process.env.MQTTURL,
    username: process.env.MQTTUSER
    clientId: guid()
    incomingStore: incoming
    outgoingStore: outgoing
    clean: false
  .on 'connect', ->
    client.subscribe process.env.MQTTTOPIC, qos: 2
client.apply = (list) ->
  client.on 'message', (topic, msg) ->
    if topic == process.env.MQTTTOPIC
      try
        msg = JSON.parse msg
      catch err
        console.error "#{msg}: #{err.toString()}"
      for item in list
        if msg.symbol == parseInt item.symbol
          switch msg.src
            when 'ib'
              item.quote = msg.quote
              item.currTotal = item.quote.curr * item.quantity
            when 'aastocks'
              item.details = msg.details
          item.diffTotal = item.currTotal - item.total
          item.diffPercent = item.diffTotal * 100 / item.total
          item

export default client
</script>
