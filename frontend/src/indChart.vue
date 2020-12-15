<template>
  <v-btn icon x-small :href='url' target='_blank'>
    <v-icon>mdi-finance</v-icon>
  </v-btn>
</template>

<script lang='coffee'>
{symbol} = require 'analysis'

module.exports =
  props: [
    'symbol'
  ]
  computed:
    url: ->
      code = symbol.yahoo @symbol
      "/chart/#/stock/#{code}"
</script>
