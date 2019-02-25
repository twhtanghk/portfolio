<template>
  <div>
    <model ref='hold' :eventBus='eventBus' baseUrl='api/portfolio/hold' />
    <b-table striped hover :items='list' :fields='fields'>
      <template slot='symbol' slot-scope='data'>
        <quote :symbol='data.value' />
      </template>
      <template slot='change' slot-scope='data'>
        <span :class='style(data.value)'>{{float(data.value)}}</span>
      </template>
      <template slot='percent' slot-scope='data'>
        <span :class='style(data.value)'>{{float(data.value)}}</span>
      </template>
      <template slot='bottom-row' slot-scope='data'>
        <td :colspan='15'>
          Total: {{float(sum.total)}} Change: {{float(sum.diffTotal)}} Percent: {{float(sum.percent)}}
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

export default
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
      { key: 'quantity', sortable: true, formatter: @float }
      { key: 'cost', sortable: false, formatter: @float }
      { key: 'price', sortable: false, formatter: @float }
      { key: 'maxPrice', sortable: false, formatter: @float }
      { key: 'avgPrice', sortable: false, formatter: @float }
      { key: 'marketPrice', sortable: false, formatter: @float }
      { key: 'div', sortable: true, formatter: @float }
      { key: 'yield', sortable: true, formatter: @float }
      { key: 'exDivDate', sortable: true, formatter: format.date }
      { key: 'pe', label: 'PE', sortable: true, formatter: @float }
      { key: 'total', sortable: true, formatter: @float }
      { key: 'change', sortable: true }
      { key: 'percent', sortable: true }
    ]
  methods:
    style: (val) ->
      if val >= 0 then 'profit' else 'loss'
    float: format.float
    format: (item) ->
      avgPrice = item.price / item.quantity
      cost =  avgPrice * item.quantity
      curr = item.marketPrice * item.quantity
      diff = curr - cost
      symbol: item.symbol
      name: item.name
      quantity: item.quantity
      cost: cost
      total: curr
      change: diff
      percent: (diff / cost) * 100
      marketPrice: item.marketPrice
      maxPrice: item.maxPrice
      avgPrice: avgPrice
      price: item.price
      div: item.dividend.rate
      yield: item.dividend.yield * 100
      exDivDate: item.dividend.exdate
      pe: item.pe
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
      _.extend ret, percent: if ret.total != 0 then 100 * ret.diffTotal / ret.total else 0
  asyncComputed:
    list: ->
      opts = @opts
      res = await @$refs.hold?.list opts
      res?.map (item) =>
        @format item
</script>

<style>
.profit {
  color: green;
}

.loss {
  color: red;
}
</style>
