<template>
  <a :href='url' target='_blank'>{{symbol}}</a>
</template>

<script lang='coffee'>
module.exports =
  props: [
    'symbol'
  ]
  computed:
    url: ->
      "http://www.aastocks.com/tc/stocks/quote/detail-quote.aspx?symbol=#{@symbol}"
</script>
