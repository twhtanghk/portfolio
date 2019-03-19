<template>
  <row>
    <template v-slot:col1>
      <div>
        {{item.name}}
        <quote :symbol='item.symbol'/>
      </div>
      <div :class='{profit: item.quote.change[0] > 0, loss: item.quote.change[0] < 0}'>
       {{float(item.quote.change[0])}} / {{float(item.quote.change[1])}}%
      </div>
    </template>
    <template v-slot:col2>
      <div>{{float(item.quantity)}}</div>
      <div>{{float(item.price)}} / {{float(item.quote.curr)}}</div>
    </template>
    <template v-slot:col3>
      <div v-if='item.details'>{{float(item.details.pe)}} / {{float(item.details.pb)}}</div>
      <div v-if='item.details && item.details.dividend && Array.isArray(item.details.dividend)'>
       {{float(item.details.dividend[0])}} / {{float(item.details.dividend[1])}}% /
       <a :href='item.details.dividend[2]'>details</a>
      </div>
    </template>
    <template v-slot:col4>
      <div>{{float(item.total)}} / {{float(item.currTotal)}}</div>
      <div :class='{profit: item.diffTotal > 0, loss: item.diffTotal < 0}'>
        {{float(item.diffTotal)}} / {{float(item.diffPercent)}}%
      </div>
    </template>
  </row>
</template>

<script lang='coffee'>
format = require('./format').default

export default
  props: [
    'item'
  ]
  components:
    row: require('./row').default
    quote: require('./quote').default
  methods:
    date: format.date
    float: format.float
</script>
