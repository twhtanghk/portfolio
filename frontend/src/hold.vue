<template>
  <v-container fluid>
    <v-layout column>
      <v-flex xs12>
        <row class='portfolio-header'>
          <template v-slot:col1>
            <div>Name</div>
            <div>Daily Change</div>
          </template>
          <template v-slot:col2>
            <div>Quantity</div>
            <div>
              <span>Price</span>/<span>Current</span>
            </div>
          </template>
          <template v-slot:col3>
            <div>
              <span>PE</span>/<span>PB</span>
            </div>
            <div>Dividend</div>
          </template>
          <template v-slot:col4>
            <div>Total</div>
            <div>P&ampL</div>
          </template>
        </row>
        <holditem :class='{odd: index % 2 == 1}' v-for='(item, index) in list' :item='item' :key='item._id'/>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script lang='coffee'>
_ = require 'lodash'
{eventBus} = require('jsOAuth2/frontend/src/lib').default
{Portfolio} = require('./model').default
client = require('./mqtt').default

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
        client.publish process.env.MQTTTOPIC, JSON.stringify
          action: 'subscribe'
          data: _.map res, (item) ->
            parseInt item.symbol
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
    client.apply @list
    eventBus
      .$on 'tags.changed', ({tags}) =>
        @tags.splice 0, @tags.length
        for i in tags
          @tags.push i
</script>
