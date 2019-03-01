<template>
  <v-list two-line>
    <v-list-tile v-for='item in list' :key='item._id'>
      <holditem :item='item' />
    </v-list-tile>
  </v-list>
</template>

<script lang='coffee'>
_ = require 'lodash'
{eventBus} = require('jsOAuth2/frontend/src/lib').default
{Portfolio} = require('./model').default

export default
  components:
    holditem: require('./holditem').default
  data: ->
    list: []
  created: ->
    eventBus.$on 'tags.changed', ({tags}) =>
      @list.splice 0, @list.length
      res = await Portfolio.get
        url: 'api/portfolio/hold'
        data: 
          tags:
            $in: tags
          sort: 
            date: 1
      for i in res
        @list.push i
</script>
