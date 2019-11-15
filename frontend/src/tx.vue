<template>
  <v-container fluid>
    <v-btn color='primary' fixed fab bottom right @click='showAdd = true'>
      <v-icon>add</v-icon>
    </v-btn>
    <v-data-table
      :headers='headers'
      :items='list'
      disable-pagination
      fixed-header
      hide-default-footer
    >
      <template v-slot:item.date="{ item }">
        <span>{{date(item.date)}}</span>
      </template>
      <template v-slot:item.total="{ item }">
        <span>{{float(item.total)}}</span>
      </template>
    </v-data-table>
  </v-container>
</template>

<script lang='coffee'>
eventBus = require('./eventBus').default
format = require('./format').default
{Portfolio} = require('./model').default
client = require('./mqtt').default
{required, numeric, decimal} = require 'vuelidate/lib/validators'

export default
  components:
    txitem: require('./txitem').default
    row: require('./row').default
  props:
    tab: String
  data: ->
    headers: [
      { text: 'Name', value: 'name' }
      { text: 'Symbol', value: 'symbol' }
      { text: 'Quantity', value: 'quantity' }
      { text: 'Type', value: 'type' }
      { text: 'Price', value: 'price' }
      { text: 'Date', value: 'date' }
      { text: 'Tags', value: 'tags' }
      { text: 'Notes', value: 'notes' }
      { text: 'Total', value: 'total' }
      { text: 'P&L', value: 'diffTotal' }
    ] 
    list: []
    tags: []
    sort:
      date: 1
    tx:
      symbol: ''
      type: 'Buy'
      date: new Date().toISOString().substr(0, 10)
      quantity: 0
      price: 0
      notes: ''
      tags: []
    menu: false
    showAdd: false
  validations:
    'tx.symbol': {required, numeric}
    'tx.quantity': {required, numeric}
    'tx.price': {required, decimal}
  methods:
    date: format.date
    float: format.float
    add: ->
      @tx.quantity = parseInt @tx.quantity
      @tx.price = parseFloat @tx.price
      @tx.tags = @tags
      @list.unshift await Portfolio.create data: @tx
      @showAdd = false
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
