<template>
  <div/>
</template>

<script lang='coffee'>
Plotly = require 'plotly.js/lib/core'

export default
  props: ['sector']
  mounted: ->
    {url, name, data} = @sector
    x = []
    y = []
    data.map ({_id, ad}) ->
      x.push _id
      y.push ad
    plot = await Plotly.react @$el,
      data: [
        {x, y, name, type: 'scatter'}
      ]
      layout:
        title:
          text: name
        xaxis:
          type: 'category'
    plot.on 'plotly_click', ->
      window.open url
</script>
