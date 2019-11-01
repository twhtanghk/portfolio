<template>
  <v-app-bar app color='primary'>
    <v-app-bar-nav-icon @click.stop="clickNav" class="white--text"/>
    <v-toolbar-title class="white--text">
      Portfolio
    </v-toolbar-title>
    <v-spacer />
    <tags />
  </v-app-bar>
</template>

<script lang='coffee'>
eventBus = require('./eventBus').default

export default
  components:
    tags: require('./tags').default
  data: ->
    drawer: false
  methods:
    clickNav: ->
      eventBus.$emit 'clickNav'
</script>
