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
      "https://hk.finance.yahoo.com/quote/#{@symbol}.HK"
</script>
