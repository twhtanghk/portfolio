<template>
  <v-navigation-drawer
    v-model="drawer"
    app
  >
    <v-list dense>
      <v-list-item link @click.stop='content("portfolio")'>
        <v-list-item-action>
          <v-icon>mdi-view-list</v-icon>
        </v-list-item-action>
        <v-list-item-content>
          <v-list-item-title>Portfolio</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
      <v-list-item link @click.stop='content("sector")'>
        <v-list-item-action>
          <v-icon>mdi-chart-line</v-icon>
        </v-list-item-action>
        <v-list-item-content>
          <v-list-item-title>AD Line</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
    </v-list>
  </v-navigation-drawer>
</template>

<script lang='coffee'>
eventBus = require('./eventBus').default

export default
  data: ->
    drawer: false
  created: ->
    eventBus.$on 'clickNav', =>
      @drawer = !@drawer
  methods:
    content: (page) ->
      eventBus.$emit 'content', page
</script>
