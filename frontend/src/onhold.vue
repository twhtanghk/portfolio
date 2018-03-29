<template>
  <div>
    <model ref='onhold' :eventBus='eventBus' baseUrl='http://172.22.0.3:1337/api/portfolio/onhold' />
    <b-table striped hover :items='list' :fields='fields'>
      <template slot='symbol' slot-scope='data'>
        <quote :symbol='data.value' />
      </template>
      <template slot='bottom-row' slot-scope='data'>
        <td :colspan='11'>
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
      { key: 'cost', sortable: false, formatter: format.float }
      { key: 'price', sortable: false, formatter: format.float }
      { key: 'maxPrice', sortable: false, formatter: format.float }
      { key: 'avgPrice', sortable: false, formatter: format.float }
      { key: 'marketPrice', sortable: false }
      { key: 'total', sortable: true, formatter: format.float }
      { key: 'change', sortable: true, formatter: format.float }
      { key: 'percent', sortable: true, formatter: format.float }
    ]
  methods:
    format: (item) ->
      avgPrice = item.price / item.quantity
      cost =  avgPrice * item.quantity
      curr = item.marketPrice * item.quantity
      diff = curr - cost
      _.extend item,
         cost: cost
         total: curr
         change: diff
         percent: (diff / cost) * 100
         avgPrice: avgPrice
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
      opts = @opts
      res = await @$refs.onhold?.list opts
      res?.map (item) =>
        @format item
</script>
