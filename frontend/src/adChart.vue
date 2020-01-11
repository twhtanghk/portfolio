<template>
  <div/>
</template>

<script lang='coffee'>
c3 = require 'c3'

export default
  props: ['sector']
  mounted: ->
    {url, name, data} = @sector
    c3.generate
      bindto: @$el
      data:
        json: data
        keys:
          value: ['_id', 'ad']
        x: '_id'
        names:
          ad: name
      axis:
        x:
          type: 'category'
      legend:
        item:
          onclick: ->
            window.open url
</script>
