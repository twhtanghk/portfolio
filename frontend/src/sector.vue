<template>
  <v-container>
    <v-row v-for='sector in sectors'>
      <v-col cols='12'>
        <a :href='sector.url' target='_blank'>{{sector.name}}</a>
        <ad-chart :sector='sector.url' :name='sector.name'/>
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
