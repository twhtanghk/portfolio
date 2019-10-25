<template>
  <v-app-bar app color='primary'>
    <v-toolbar-title class="white--text">
      Portfolio
    </v-toolbar-title>
    <v-spacer />
    <tags />
  </v-app-bar>
</template>

<script lang='coffee'>
{eventBus} = require('jsOAuth2/frontend/src/lib').default

export default
  components:
    tags: require('./tags').default
  methods:
    create: ->
      eventBus.$emit 'tx.add'
</script>
