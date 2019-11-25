<script lang='coffee'>
mqtt = require 'stockmqtt'
update = null
client = mqtt()
client.apply = (list) ->
  update = (topic, msg) ->
    try
      msg = JSON.parse msg.toString()
    catch err
      console.error "#{msg}: #{err.toString()}"
    mergeQuote = (item, msg) ->
      item.quote = Object.assign item.quote, msg.quote
      item.currTotal = item.quote.curr * item.quantity
      item.stopLoss = parseFloat(process.env.STOPLOSS) * Math.max item.price, msg.history['1個月'].high
    for item in list
      if msg.symbol == parseInt item.symbol
        switch msg.src
          when 'ib'
            mergeQuote item, msg
          when 'aastocks'
            mergeQuote item, msg
            item.details = Object.assign item.details, msg.details
            item['history'] = msg.history
            if item.details.dividend[3]?
              item.details.dividend[3] = new Date item.details.dividend[3]
            item.name = msg.name
        item.diffTotal = item.currTotal - item.total
        item.diffPercent = item.diffTotal * 100 / item.total

  if update?
    client.off 'message', update

  client.on 'message', update

  client.publish process.env.MQTTTOPIC, JSON.stringify
    action: 'subscribe'
    data: _.map list, (item) ->
      parseInt item.symbol

export default client
</script>
