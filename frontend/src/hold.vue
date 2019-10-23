<template>
  <v-container fluid>
    <v-layout column>
      <v-flex>
        <row class='portfolio-header'>
          <template v-slot:col1>
            <div>
              Name
              <order @sort="sort('name', $event)" />
              Symbol
              <order @sort="sort('symbol', $event)" />
            </div>
            <div>
              Daily Change
              <order @sort="sort('quote.change[1]', $event)" />
            </div>
          </template>
          <template v-slot:col2>
            <div>
              Quantity
              <order @sort="sort('quantity', $event)" />
            </div>
            <div>
              Price
              <order @sort="sort('price', $event)" />
              Current / NAV
            </div>
          </template>
          <template v-slot:col3>
            <div>
              PE
              <order @sort="sort('details.pe', $event)" />
              PB
              <order @sort="sort('details.pb', $event)" />
            </div>
            <div>
              Dividend
              <order @sort="sort('details.dividend[1]', $event)" />
              Ex-date
              <order @sort="sort('details.dividend[3]', $event)" />
            </div>
          </template>
          <template v-slot:col4>
            <div>
              Total
              <order @sort="sort('total', $event)" />
              Current
              <order @sort="sort('currTotal', $event)" />
            </div>
            <div>
              P&ampL
              <order @sort="sort('diffPercent', $event)" />
            </div>
          </template>
        </row>
        <holditem :class='{odd: index % 2 == 1}' v-for='(item, index) in list' :item='item' :key='item._id'/>
        <row class='portfolio-footer'>
          <template v-slot:col4>
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
        </row>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script lang='coffee'>
_ = require 'lodash'
d3 = require 'd3'
format = require('./format').default
{eventBus} = require('jsOAuth2/frontend/src/lib').default
{Portfolio} = require('./model').default
client = require('./mqtt').default

export default
  components:
    holditem: require('./holditem').default
    row: require('./row').default
    order: require('./order').default
  props:
    tab: String
  data: ->
    list: []
    tags: []
    order: []
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
    sort: (prop, value) ->
      index = _.findIndex @order, prop
      if value
        if index != -1
          @order[index][prop] = value
        else
          ret = {}
          ret[prop] = value
          @order.push ret
      else
        @order.splice index, 1
    reload: ->
      try
        @list.splice 0, @list.length
        data = sort:
          date: 1
        if @tags.length
          data.tags = $in: @tags
        res = await Portfolio.get
          url: "#{Portfolio.baseUrl}/hold"
          data: data
        for i in res
          @list.push i
        client.publish process.env.MQTTTOPIC, JSON.stringify
          action: 'subscribe'
          data: _.map res, (item) ->
            parseInt item.symbol
      catch err
        console.error err.toString()
  watch:
    order:
      handler: (after, before) ->
        compare = _.map @order, (obj) ->
          [prop, order] = Object.entries(obj)[0]
          (a, b) ->
            order * (_.get(a, prop) - _.get(b, prop))
        @list.sort (a, b) ->
          for i in compare
            ret = i(a, b)
            if ret != 0
              return ret
          return 0
      deep: true
    tab: (newtab, oldtab) ->
      if newtab == 'hold'
        @reload()
    tags: (newtags, oldtags) ->
      if @tab == 'hold'
        @reload()
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
