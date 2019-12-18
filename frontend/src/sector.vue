<template>
  <div>
    <div v-for='sector in sectors'>
      <a :href='sector' target='_blank'>{{sector}}</a>:
      <div v-for='row in ad[sector]'>
        {{row}}
      </div>
    </div>
  </div>
</template>

<script lang='coffee'>
{Sector} = require('./model').default

export default
  data: ->
    sectors: []
    ad: {}
  created: ->
    @sectors = await Sector.list()
    for sector in @sectors
      @ad[sector] = await Sector.ad data: sector: sector
    @$forceUpdate()
</script>
