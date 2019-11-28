<template>
  <div>
    <v-tabs fixed-tabs color='cyan' slider-color='yellow' @change='change' v-model='index'>
      <v-tab>
        Hold
      </v-tab>
      <v-tab>
        TX
      </v-tab> 
    </v-tabs>
    <v-tabs-items touchless v-model='index'>
      <v-tab-item>
        <hold :tab='tab'/>
      </v-tab-item>
      <v-tab-item>
        <tx :tab='tab'/>
      </v-tab-item>
    </v-tabs-items>
  </div>
</template>

<script lang='coffee'>
eventBus = require('./eventBus').default

export default
  components:
    tx: require('./tx').default
    hold: require('./hold').default
  data: ->
    tab: 'hold'
    index: 0
  methods:
    change: (tab) ->
      @tab = ['hold', 'tx'][tab]
</script>
