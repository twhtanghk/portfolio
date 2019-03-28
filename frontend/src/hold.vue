<template>
  <v-container fluid>
    <v-layout column>
      <v-flex>
        <row class='portfolio-header'>
          <template v-slot:col1>
            <div>
              Name
              <order @sort="sort('name', $event)" />
              /
              Symbol
              <order @sort="sort('symbol', $event)" />
            </div>
            <div>Daily Change</div>
          </template>
          <template v-slot:col2>
            <div>Quantity</div>
            <div>
              <span>Price</span>/<span>Current</span>
            </div>
          </template>
          <template v-slot:col3>
            <div>
              PE
              <order @sort="sort('details.pe', $event)" />
              /
              PB
              <order @sort="sort('details.pb', $event)" />
            </div>
            <div>Dividend</div>
          </template>
          <template v-slot:col4>
            <div>
              Total
              <order @sort="sort('total', $event)" />
              /
              Current
              <order @sort="sort('currTotal', $event)" />
            </div>
            <div>P&ampL</div>
          </template>
        </row>
        <holditem :class='{odd: index % 2 == 1}' v-for='(item, index) in list' :item='item' :key='item._id'/>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script lang='coffee'>
_ = require 'lodash'
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
  methods:
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
        console.log JSON.stringify after
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
