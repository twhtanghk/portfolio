<template>
  <div>
    <model ref='onhold' :eventBus='eventBus' baseUrl='http://172.23.0.3:1337/api/portfolio/onhold' />
    <b-table striped hover :items='list' :fields='fields'>
      <template slot='symbol' slot-scope='data'>
        <quote :symbol='data.value' />
      </template>
    </b-table>
  </div>
</template>

<script lang='coffee'>
_ = require 'lodash'
d3 = require 'd3'
Vue = require('vue').default
Vue.use require('bootstrap-vue').default
eventBus = require('vue.oauth2/src/eventBus').default

format = require('./format').default

module.exports =
  components:
    quote: require('./quote').default
  props: [
    'tags'
  ]
  data: ->
    eventBus: eventBus
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
    list: []
  mounted: ->
    opts =
      or: @tags.map (tag) ->
        tags:
          contains: tag
    @$refs.onhold
      .list opts
      .then (collection) =>
        collection.map (item) =>
          diff =  (item.marketPrice * item.quantity) - item.price
          @list.push _.extend item,
            total: item.quantity * item.marketPrice
            change: diff
            percent: (diff / item.price) * 100
</script>
