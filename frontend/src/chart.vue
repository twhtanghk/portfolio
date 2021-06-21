<template>
  <v-btn icon x-small :href='url' target='_blank'>
    <v-icon>mdi-poll</v-icon>
  </v-btn>
</template>

<script lang='coffee'>
module.exports =
  props: [
    'symbol'
  ]
  computed:
    url: ->
      process.env.CHART_URL.replace /#{symbol}/, @symbol.replace(/^0+/, '')
</script>
