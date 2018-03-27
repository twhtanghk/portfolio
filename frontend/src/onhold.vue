<template>
  <b-table striped hover :items='list' :fields='fields'>
    <template slot='symbol' slot-scope='data'>
      <quote :symbol='data.value' />
    </template>
  </b-table>
</template>

<script lang='coffee'>
_ = require 'lodash'
d3 = require 'd3'
Vue = require('vue').default
Vue.use require('bootstrap-vue').default

format = require('./format').default

module.exports =
  components:
    quote: require('./quote').default
  props: [
    'collection'
  ]
  data: ->
    fields: [
      { key: 'symbol', sortable: true }
      { key: 'name', sortable: true }
      { key: 'quantity', sortable: true }
      { key: 'price', sortable: false, formatter: format.float }
      { key: 'marketPrice', sortable: false }
      { key: 'total', sortable: true, formatter: format.float }
      { key: 'change', sortable: true, formatter: format.float }
      { key: 'percent', sortable: true, formatter: format.float }
    ]
  computed:
    list: ->
      @collection.map (item) ->
        diff =  (item.marketPrice * item.quantity) - item.price
        _.extend item,
          total: item.quantity * item.marketPrice
          change: diff
          percent: (diff / item.price) * 100
</script>
