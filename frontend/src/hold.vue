<template>
  <v-container fluid>
    <v-data-table
      :headers='headers'
      :items='list'
      disable-pagination
      fixed-header
      hide-default-footer
      multi-sort
    >
      <template v-slot:item.symbol="{ item }">
        <quote :symbol='item.symbol'/>
        <chart :symbol='item.symbol'/>
      </template>
      <template v-slot:item.quote.change="{ item }">
        <span :class='changeClass(item.quote.change[0], 0)'>
          <div>{{item.quote.change[0]}}</div>
          <div>{{float(item.quote.change[1])}}%</div>
        </span>
      </template>
      <template v-slot:item.quantity="{ item }">
        {{float(item.quantity)}}
      </template>
      <template v-slot:item.quote.curr="{ item }">
        <div>{{item.quote.curr}}</div>
        <div>{{float(item.details.nav)}}</div>
      </template>
      <template v-slot:item.stopLoss="{ item }">
        <span :class='changeClass(item.stopLoss, item.price)'>
          {{float(item.stopLoss)}}
        <span>
      </template>
      <template v-slot:item.details.pe="{ item }">
        {{float(item.details.pe)}}
      </template>
      <template v-slot:item.details.pb="{ item }">
        {{float(item.details.pb)}}
      </template>
      <template v-slot:item.details.dividend="{ item }">
        <div>
          {{float(item.details.dividend[0])}}/{{float(item.details.dividend[1])}}%
        </div>
        <a :href='item.details.dividend[2]' target='_blank'>
          {{date(item.details.dividend[3])}}
        </a>
      </template>
      <template v-slot:item.total="{ item }">
        <div>{{float(item.total)}}</div>
        <div>{{float(item.currTotal)}}</div>
      </template>
      <template v-slot:item.diffPercent="{ item }">
        <span :class='changeClass(item.diffPercent, 0)'>
          <div>{{float(item.diffTotal)}}</div>
          <div>{{float(item.diffPercent)}}%</div>
        </span
      </div>
      </template>
      <template v-slot:footer>
         <div>
           {{float(sumTotal)}}
           /
           {{float(sumCurrTotal)}}
         </div>
         <div>
           {{float(sumDiffTotal)}}
           /
           {{float(sumDiffTotalPercent)}}%
         </div>
      </template>
    </v-data-table>
  </v-container>
</template>

<script lang='coffee'>
_ = require 'lodash'
d3 = require 'd3'
format = require('./format').default
eventBus = require('./eventBus').default
{Portfolio} = require('./plugins/model.coffee').default
client = require('./mqtt').default

export default
  components:
    quote: require('./quote').default
    chart: require('./chart').default
  props:
    tab: String
  data: ->
    list: []
    tags: []
    headers: [
      { text: 'Symbol', value: 'symbol' }
      { text: 'Name', value: 'name' }
      { 
        text: 'Daily Change'
        value: 'quote.change'
        sort: (a, b) ->
          a[1] - b[1]
      }
      { text: 'Quantity', value: 'quantity' }
      { text: 'Price', value: 'price', sort: @sort }
      { text: 'Current / NAV', value: 'quote.curr', sort: @sort }
      { text: 'StopLoss', value: 'stopLoss' }
      { text: 'PE', value: 'details.pe' }
      { text: 'PB', value: 'details.pb' }
      { 
        text: 'Dividend'
        value: 'details.dividend' 
        sort: (a, b) ->
          a[1] - b[1]
      }
      { text: 'Total', value: 'total' }
      { text: 'Change', value: 'diffPercent' }
    ]
  computed:
    sumTotal: ->
      d3.sum @list, (quote) ->
        quote.total
    sumCurrTotal: ->
      d3.sum @list, (quote) ->
        quote.currTotal
    sumDiffTotal: ->
      d3.sum @list, (quote) ->
        quote.diffTotal
    sumDiffTotalPercent: ->
      @sumDiffTotal * 100 / @sumTotal
  methods:
    float: format.float
    date: format.date
    changeClass: (curr, org) ->
      profit: curr > org
      loss: curr < org
    sort: (a, b) ->
      a - b
    load: ->
      try
        @list.splice 0, @list.length
        data = sort:
          date: -1
        if @tags.length
          data.tags = $in: @tags
        res = await Portfolio.get
          url: "#{Portfolio.baseUrl}/hold"
          data: data
        for i in res
          @list.push i
        client.apply @list
      catch err
        console.error err.toString()
  watch:
    tab: (newtab, oldtab) ->
      if newtab == 'hold'
        @load()
    tags: (newtags, oldtags) ->
      if @tab == 'hold'
        @load()
  created: ->
    client.apply @list
    eventBus
      .$on 'tags.changed', ({tags}) =>
        @tags.splice 0, @tags.length
        for i in tags
          @tags.push i
</script>

<style lang='scss' scoped>
.portfolio-header * {
  vertical-align: middle;
}
</style>
