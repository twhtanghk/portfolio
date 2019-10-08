<template>
  <v-container fluid>
    <v-btn color='primary' fixed fab bottom right @click='add'>
      <v-icon>add</v-icon>
    </v-btn>
    <v-layout column v-scroll='nextPage'>
      <v-flex xs12>
        <row class='portfolio-header'>
          <template v-slot:col1>
            <div>Name</div>
            <div>Daily Change</div>
          </template>
          <template v-slot:col2>
            <div>Quantity</div>
            <div>Type / Price / Date</div>
          </template>
          <template v-slot:col3>
            <div>Tag</div>
          </template>
          <template v-slot:col4>
            <div>Total</div>
            <div>P&ampL</div>
          </template>
        </row>
        <txitem :class='{odd: index % 2 == 1}' v-for='(item, index) in list' :item='item' :key='item._id'/>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script lang='coffee'>
{eventBus} = require('jsOAuth2/frontend/src/lib').default
{Portfolio} = require('./model').default
client = require('./mqtt').default

export default
  components:
    txitem: require('./txitem').default
    row: require('./row').default
  props:
    tab: String
  data: ->
    list: []
    tags: []
    sort:
      date: 1
    tx:
      symbol: ''
      type: 'Buy'
      date: new Date.toISODateString()
      quantity: 0
      price: 0
      notes: ''
      tags: @tags
  methods:
    add: ->
      console.log 'add'
    nextPage: ->
      if document.documentElement.scrollTop + window.innerHeight == document.documentElement.offsetHeight
        @load @list.length
    load: (skip = 0) ->
      if skip == 0
        @list.splice 0, @list.length
      try
        data =
          sort: @sort
          skip: skip
        if @tags.length
          data.tags = $in: @tags
        res = await Portfolio.get data: data
        for i in res
          @list.push i
      catch err
        console.error err.toString()
  watch:
    tab: (newtab, oldtab) ->
      if newtab == 'tx'
        @load()
    tags: (newtags, oldtags) ->
      if @tab == 'tx'
        @load()
  created: ->
    client.apply @list
    eventBus
      .$on 'tags.changed', ({tags}) =>
        @tags.splice 0, @tags.length
        for i in tags
          @tags.push i
</script>
