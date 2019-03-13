<script lang='coffee'>
mqtt = require 'mqtt'
client = mqtt
  .connect process.env.MQTTURL,
    username: process.env.MQTTUSER
  .on 'connect', ->
    client.subscribe process.env.MQTTTOPIC
client.apply = (list) ->
  client.on 'message', (topic, quote) ->
    if topic == process.env.MQTTTOPIC
      try
        quote = JSON.parse quote
      catch err
        console.error "#{quote}: #{err.toString()}"
      for item in list
        if quote.symbol == parseInt item.symbol
          item.lastUpdatedAt = new Date quote.date
          item.currTotal = quote.currPrice * item.quantity
          item.diffTotal = item.currTotal - item.total
          item.diffPercent = item.diffTotal * 100 / item.total
          _.extend item, _.omit(quote, 'symbol', 'date')

export default client
</script>
