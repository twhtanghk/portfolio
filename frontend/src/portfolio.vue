<template>
  <v-tabs fixed-tabs color='cyan' slider-color='yellow' @change='change'>
    <v-tab>
      Hold
    </v-tab>
    <v-tab>
      TX
    </v-tab> 
    <v-tab-item>
      <hold :tab='tab'/>
    </v-tab-item>
    <v-tab-item>
      <tx :tab='tab'/>
    </v-tab-item>
  </v-tabs>
</template>

<script lang='coffee'>
eventBus = require('./eventBus').default

export default
  components:
    tx: require('./tx').default
    hold: require('./hold').default
  data: ->
    tab: 'hold'
  methods:
    change: (tab) ->
      @tab = ['hold', 'tx'][tab]
</script>
