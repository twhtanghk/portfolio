<template>
  <v-container>
    <v-row v-for='sector in sectors'>
      <v-col cols='12'>
        <ad-chart :sector='sector'/>
      </v-col>
    </v-row>
  </v-container>
</template>

<script lang='coffee'>
{Sector} = require('./model').default

export default
  components:
    adChart: require('./adChart').default
  data: ->
    sectors: []
  mounted: ->
    @sectors = await Sector.list()
</script>
