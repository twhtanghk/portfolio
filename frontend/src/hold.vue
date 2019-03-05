<template>
  <v-container fluid>
    <v-layout column>
      <v-flex xs12>
        <row class='portfolio-header'>
          <template v-slot:header>
            <div>name</div><div>symbol</div>
          </template>
          <template v-slot:content>
            <div>quantity</div><div>price</div>
          </template>
          <template v-slot:footer></template>
        </row>
        <holditem v-for='item in list' :item='item' :key='item._id'/>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script lang='coffee'>
_ = require 'lodash'
{eventBus} = require('jsOAuth2/frontend/src/lib').default
{Portfolio} = require('./model').default

export default
  components:
    holditem: require('./holditem').default
    row: require('./row').default
  props:
    tab: String
  data: ->
    list: []
    tags: []
    sort:
      date: 1
  methods:
    reload: ->
      try
        @list.splice 0, @list.length
        data = sort: @sort
        if @tags.length
          data.tags = $in: @tags
        res = await Portfolio.get
          url: "#{Portfolio.baseUrl}/hold"
          data: data
        for i in res
          @list.push i
      catch err
        console.error err.toString()
  watch:
    tab: (newtab, oldtab) ->
      if newtab == 'hold'
        @reload()
    tags: (newtags, oldtags) ->
      if @tab == 'hold'
        @reload()
  created: ->
    eventBus
      .$on 'tags.changed', ({tags}) =>
        @tags.splice 0, @tags.length
        for i in tags
          @tags.push i
</script>
