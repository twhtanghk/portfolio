<template>
  <row>
    <template v-slot:col1>
      <div>
        {{item.name}}
        <quote :symbol='item.symbol'/>
      </div>
      <div v-if='Array.isArray(item.change)' :class='{profit: item.change[0] > 0, loss: item.change[0] < 0}'>
       {{float(item.change[0])}} / {{float(item.change[1])}}%
      </div>
    </template>
    <template v-slot:col2>
      <div>{{float(item.quantity)}}</div>
      <div>{{float(item.price)}} / {{float(item.currPrice)}}</div>
    </template>
    <template v-slot:col3>
      <div>{{float(item.pe)}} / {{float(item.pb)}}</div>
      <div v-if='Array.isArray(item.dividend)'>
       {{float(item.dividend[0])}} / {{float(item.dividend[1])}}% /
       <a :href='item.dividend[2]'>details</a>
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
