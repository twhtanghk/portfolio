<template>
  <div>
    <div v-for='(data, sector) in ad'>
      {{sector}}:
      <div v-for='row in data'>
        {{row}}
      </div>
    </div>
  </div>
</template>

<script lang='coffee'>
{Sector} = require('./model').default

export default
  data: ->
    ad: 
      HSI: []
      material: []
      communication: []
      consumerDiscretionary: []
      consumerStaples: []
      energy: []
      financial: []
      healthcare: []
      industrial: []
      IT: []
  created: ->
    for sector, data of @ad
      @ad[sector] = await Sector.ad data: sector: sector
      console.log @ad
</script>
