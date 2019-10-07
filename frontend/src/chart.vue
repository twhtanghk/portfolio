<template>
  <v-btn text icon x-small :href='url' target='_blank'>
    <v-icon>bar_chart</v-icon>
  </v-btn>
</template>

<script lang='coffee'>
module.exports =
  props: [
    'symbol'
  ]
  computed:
    url: ->
      "http://www.aastocks.com/tc/stocks/quote/detailchart.aspx?symbol=0#{@symbol}"
</script>
