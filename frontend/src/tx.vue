<template>
  <v-container fluid>
    <v-layout column>
      <v-flex xs12>
        <row class='portfolio-header'>
          <template v-slot:header>
            <div>name</div><div>symbol</div>
          </template>
          <template v-slot:content>
            <div>type</div>
            <div>date</div>
            <div>quantity</div>
            <div>price</div>
          </template>
          <template v-slot:footer>
            <div>tags</div>
            <div>total</div>
          </template>
        </row>
        <holditem v-for='item in list' :item='item' :key='item._id'/>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script lang='coffee'>
{eventBus} = require('jsOAuth2/frontend/src/lib').default
{Portfolio} = require('./model').default

export default
  components:
    txitem: require('./txitem').default
    row: require('./row').default
  props:
    tags: Array
  data: ->
    list: []
  methods:
    reload: ->
      @list.splice 0, @list.length
      res = await Portfolio.get
        data: 
          tags:
            $in: tags
          sort: 
            date: 1
      for i in res
        @list.push i
  created: ->
    eventBus.$on 'tab.selected', (tab) =>
      if tab == 1
        @reload()
</script>
