<template>
  <div/>
</template>

<script lang='coffee'>
c3 = require 'c3'
{Sector} = require('./model').default

export default
  props: ['sector']
  mounted: ->
    c3.generate
      bindto: @$el
      data:
        json: await Sector.ad data: sector: @sector
        keys:
          value: ['_id', 'ad']
        x: '_id'
      axis:
        x:
          type: 'category'
</script>
