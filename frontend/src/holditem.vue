<template>
  <row>
    <template v-slot:header>
      <div>{{item.name}}</div>
      <div>
        <quote :symbol='item.symbol'/>
      </div>
    </template>
    <template v-slot:content>
      <div>{{float(item.quantity)}}</div>
      <div>{{float(item.price)}}</div>
    </template>
    <template v-slot:footer>
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
