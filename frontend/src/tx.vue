<template>
  <v-container fluid>
    <v-dialog v-model='dialog'>
      <template v-slot:activator='{ on }'>
        <v-btn color='primary' fixed fab bottom right v-on='on'>
          <v-icon>add</v-icon>
        </v-btn>
      </template>
      <v-card>
        <v-card-title primary-title>
          Add TX
        </v-card-title>
        <v-card-text>
          <v-text-field v-model='tx.type' label='Type' />
          <v-text-field v-model='tx.symbol' label='Symbol' />
          <v-text-field v-model='tx.quantity' label='Quantity' type='number'/>
          <v-text-field v-model='tx.price' label='Price' type='number' />
          <dt-input :value.sync='tx.date' />
          <v-text-field v-model='tx.notes' label='Notes' />
        </v-card-text>
        <v-card-actions>
          <v-btn @click='add'>Add</v-btn>
          <v-btn @click='dialog = false'>Cancel</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <v-data-table
      :headers='headers'
      :items='list'
      disable-pagination
      fixed-header
      hide-default-footer
      multi-sort
    >
      <template v-slot:top>
        <v-row no-gutters>
          <v-col sm='4'>
            <v-text-field v-model="filter.symbol" label="Symbol" clearable />
          </v-col>
          <v-col sm='4'>
            <dt-input :value.sync="filter.dtStart" label="Start Date" />
          </v-col>
          <v-col sm='4'>
            <dt-input :value.sync="filter.dtEnd" label="End Date" />
          </v-col>
      </template>
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
      <template v-slot:item.action="{ item }">
        <v-icon small @click="del(item)">
          delete
        </v-icon>
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
    dtInput: require('./dtInput').default
  props:
    tab: String
  data: ->
    headers:
      [
        { 
          text: 'Symbol'
          value: 'symbol'
          filter: @symbolFilter
        }
        { text: 'Name', value: 'name' }
        { text: 'Quantity', value: 'quantity' }
        { text: 'Type', value: 'type' }
        { text: 'Price', value: 'price' }
        { 
          text: 'Date'
          value: 'date'
          sort: (a, b) -> 
            a - b
          filter: @dateFilter
        }
        { text: 'Tags', value: 'tags' }
        { text: 'Notes', value: 'notes' }
        { text: 'Total', value: 'total' }
        { text: 'P&L', value: 'diffTotal' }
        { text: 'Action', value: 'action', sortable: false }
      ] 
    finished: false
    list: []
    tags: []
    sort:
      date: 1
    dialog: false
    filter:
      dtStart: null
      dtEnd: null
      symbol: null
    tx:
      symbol: ''
      type: 'Buy'
      date: new Date().toISOString().substr(0, 10)
      quantity: 0
      price: 0
      notes: ''
      tags: []
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
      @dialog = false
    del: (item) ->
      await Portfolio.delete data: id: item._id
      @list.splice @list.indexOf(item), 1
    next: (entries) ->
      if entries[0].isIntersecting
        @finished = 30 > await @load @list.length
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
        result.pl += tx.total * if /buy/i.test tx.type then 1 else -1
        result
      @list.reduce reducer, pl: 0
    symbolFilter: (value) ->
      if @filter.symbol? and @filter.symbol.trim() != ''
        (new RegExp @filter.symbol).test value
      else
        true
    dateFilter: (value) ->
      if @filter.dtStart? or @filter.dtEnd?
        start = @filter.dtStart
        start ?= -8640000000000000
        start = new Date start
        end = @filter.dtEnd
        end ?= 8640000000000000
        end = new Date end
        start <= value and value <= end
      else
        true
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
