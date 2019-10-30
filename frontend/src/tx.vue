<template>
  <v-container fluid>
    <v-btn color='primary' fixed fab bottom right @click='showAdd = true'>
      <v-icon>add</v-icon>
    </v-btn>
    <v-layout column v-scroll='nextPage'>
      <v-flex xs12>
        <row class='portfolio-header'>
          <template v-slot:col1>
            <div>Name</div>
            <div>Symbol</div>
          </template>
          <template v-slot:col2>
            <div>Quantity</div>
            <div>Type / Price / Date</div>
          </template>
          <template v-slot:col3>
            <div>Tag</div>
            <div>Notes</div>
          </template>
          <template v-slot:col4>
            <div>Total</div>
            <div>P&ampL</div>
          </template>
        </row>
        <row v-if='showAdd'>
          <template v-slot:col1>
            <v-text-field v-model='tx.type' label='Type' />
            <v-text-field v-model='tx.symbol' label='Symbol' />
          </template>
          <template v-slot:col2>
            <v-text-field v-model='tx.quantity' label='Quantity' type='number'/>
            <v-text-field v-model='tx.price' label='Price' type='number' />
          </template>
          <template v-slot:col3>
            <v-menu
              v-model='menu'
              :close-on-content-click="false"
              :nudge-right="40"
              transition="scale-transition"
              offset-y
              min-width="290px">
              <template v-slot:activator="{ on }">
                <v-text-field
                  v-model="tx.date"
                  prepend-icon="event"
                  label='Date'
                  readonly
                  v-on="on" />
              </template>
              <v-date-picker v-model="tx.date" no-title @input="menu = false"/>
            </v-menu>
            <v-text-field v-model='tx.notes' label='Notes' />
          </template>
          <template v-slot:col4>
            <v-btn @click='add'>Add</v-btn>
            <v-btn @click='showAdd = false'>Cancel</v-btn>
          </template>
        </row>
        <txitem :class='{odd: index % 2 == 1}' v-for='(item, index) in list' :item='item' :key='item._id'/>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script lang='coffee'>
eventBus = require('./eventBus').default
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
