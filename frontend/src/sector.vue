<template>
  <div>{{ ad }}</div>
</template>

<script lang='coffee'>
{Sector} = require('./model').default

export default
  data: ->
    ad: {}
  created: ->
    sectors = [
      'HSI'
      'material'
      'communication'
      'consumerDiscretionary'
      'consumerStaples'
      'energy'
      'financial'
      'healthcare'
      'industrial'
      'IT'
    ]
    for sector in sectors
      @ad = _.extend @ad, 
        sector: JSON.stringify await Sector.ad data: sector: sector
</script>
