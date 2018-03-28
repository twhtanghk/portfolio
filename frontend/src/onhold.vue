<template>
  <div>
    <model ref='onhold' :eventBus='eventBus' baseUrl='http://172.23.0.3:1337/api/portfolio/onhold' />
    <b-table striped hover :items='list' :fields='fields'>
      <template slot='symbol' slot-scope='data'>
        <quote :symbol='data.value' />
      </template>
      <template slot='bottom-row' slot-scope='data'>
        <td colspan='8'>
          Total: {{sum.total}} Change: {{sum.diffTotal}} Percent: {{sum.percent}}
        </td>
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
  methods:
    format: (item) ->
      diff =  (item.marketPrice * item.quantity) - item.price
      _.extend item,
         total: item.quantity * item.marketPrice
         change: diff
         percent: (diff / item.price) * 100
  computed:
    opts: ->
      ret =
        data:
          type:
            '!': null
      if @tags.length != 0
        ret.data.or = @tags?.map (tag) ->
          tags:
            contains: tag
      ret
    sum: ->
      ret =
        total: 0
        diffTotal: 0
        percent: 0
      @list?.map (item) ->
        ret.total += item.total
        ret.diffTotal += item.change
      _.extend ret, percent: if ret.total != 0 then ret.diffTotal / ret.total else 0
  asyncComputed:
    list: ->
      ret = []
      opts = @opts
      @$refs.onhold?.list opts
        .then (res) =>
          res.map (item) =>
            ret.push @format item
          ret
</script>
