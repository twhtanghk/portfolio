<script lang='coffee'>
mqtt = require 'stockmqtt'
client = mqtt()
client.apply = (list) ->
  client.on 'message', (topic, msg) ->
    try
      msg = JSON.parse msg.toString()
    catch err
      console.error "#{msg}: #{err.toString()}"
    mergeQuote = (item, msg) ->
      item.quote = Object.assign item.quote, msg.quote
      item.currTotal = item.quote.curr * item.quantity
    for item in list
      if msg.symbol == parseInt item.symbol
        switch msg.src
          when 'ib'
            mergeQuote item, msg
          when 'aastocks'
            mergeQuote item, msg
            item.details = Object.assign item.details, msg.details
            item.name = msg.name
        item.diffTotal = item.currTotal - item.total
        item.diffPercent = item.diffTotal * 100 / item.total

export default client
</script>
