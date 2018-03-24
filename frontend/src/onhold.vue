<template>
  <b-table striped hover :items='list' :fields='fields' />
</template>

<script lang='coffee'>
d3 = require 'd3'
Vue = require('vue').default
Vue.use require('bootstrap-vue').default

format = require('./format').default

module.exports =
  props: [
    'collection'
  ]
  data: ->
    fields: [
      { key: 'symbol', sortable: true }
      { key: 'name', sortable: true }
      { key: 'quantity', sortable: true }
      { key: 'price', sortable: false }
      { key: 'total', sortable: true, formatter: format.float }
      { key: 'tags', sortable: true }
    ]
  computed:
    list: ->
      ret = d3
        .nest()
        .key (item) ->
          item.symbol
        .rollup (collection) ->
          name: collection[0].name
          quantity: d3.sum collection, (item) ->
            if item.type == 'Sell' then -item.quantity else item.quantity
          tags: collection[0].tags
        .entries @collection
        .map (item) ->
          item.value.symbol = item.key
          item.value
      return ret
</script>
