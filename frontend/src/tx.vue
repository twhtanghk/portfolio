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
      <template v-slot:item.symbol="{ item }">
        <quote :symbol='item.symbol'/>
        <chart :symbol='item.symbol'/>
      </template>
      <template v-slot:item.date="{ item }">
        <span>{{date(item.date)}}</span>
      </template>
      <template v-slot:item.total="{ item }">
        <span>{{float(item.total)}} / {{float(item.currTotal)}}</span>
      </template>
      <template v-slot:item.diffTotal="{ item }">
        <span :class='{profit: item.diffTotal > 0, loss: item.diffTotal < 0}'>
          {{float(item.diffTotal)}} / {{float(item.diffPercent)}}%
        </span>
      </template>
      <template v-slot:footer>
        <v-progress-circular indeterminate color='primary'
          v-if='! finished'
          v-intersect='next' />
        Total:
        <span :class='{profit: summary().pl > 0, loss: summary().pl < 0}'>
          {{ float(summary().pl) }}
        </span>
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
    quote: require('./quote').default
    chart: require('./chart').default
  props:
    tab: String
  data: ->
    headers: [
      { text: 'Symbol', value: 'symbol' }
      { text: 'Name', value: 'name' }
      { text: 'Quantity', value: 'quantity' }
      { text: 'Type', value: 'type' }
      { text: 'Price', value: 'price' }
      { text: 'Date', value: 'date' }
      { text: 'Tags', value: 'tags' }
      { text: 'Notes', value: 'notes' }
      { text: 'Total', value: 'total' }
      { text: 'P&L', value: 'diffTotal' }
    ] 
    finished: false
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
    next: (entries) ->
      if entries[0].isIntersecting
        @finished = 0 == await @load @list.length
    clear: ->
      @list.splice 0, @list.length
      @finished = false
    load: (skip = 0) ->
      try
        data =
          sort: @sort
          skip: skip
        if @tags.length
          data.tags = $in: @tags
        res = await Portfolio.get data: data
        for i in res
          @list.push i
        client.apply @list
        return res.length
      catch err
        console.error err.toString()
    summary: ->
      reducer = (result, tx) ->
        result.pl += tx.diffTotal
        result
      @list.reduce reducer, pl: 0
  watch:
    tab: (newtab, oldtab) ->
      if newtab == 'tx'
        @clear()
    tags: (newtags, oldtags) ->
      if @tab == 'tx'
        @clear()
  created: ->
    eventBus
      .$on 'tags.changed', ({tags}) =>
        @tags.splice 0, @tags.length
        for i in tags
          @tags.push i
</script>
