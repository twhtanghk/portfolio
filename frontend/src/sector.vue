<template>
  <v-container>
    <v-row v-for='(sector, i) in sectors'>
      <v-col cols='12'>
        <a :href='sector' target='_blank'>{{names[i]}}</a>
        <ad-chart :sector='sector'/>
      </v-col>
    </v-row>
  </v-container>
</template>

<script lang='coffee'>
Promise = require 'bluebird'
{service} = require 'hkex'
{Sector} = require('./model').default

export default
  components:
    adChart: require('./adChart').default
  data: ->
    sectors: []
    names: []
  methods:
    name: (url) ->
      code = url.match /.*=([0-9]*)/
      ret = url
      if code?
        ret = await service.name code[1]
      return ret
  mounted: ->
    @sectors = await Sector.list()
    @names = await Promise.map @sectors, (s) =>
      await @name s
</script>
