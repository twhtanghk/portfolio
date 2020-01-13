<template>
  <div/>
</template>

<script lang='coffee'>
_ = require 'lodash'
Plotly = require 'plotly.js/lib/core'

export default
  props: ['sectors']
  watch:
    sectors: ->
      data = _
        .sortBy @sectors, ({data}) ->
          -data.length
        .map ({url, name, data}) ->
          x = []
          y = []
          data.map ({_id, symlog}) ->
            x.push _id
            y.push symlog
          x: x
          y: y
          name: name
          type: 'scatter'
      Plotly.react @$el,
        data: data
        layout:
          xaxis:
            type: 'category'
</script>
