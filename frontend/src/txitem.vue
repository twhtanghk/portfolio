<template>
  <row>
    <template v-slot:header>
      <div>{{item.name}}</div>
      <div>
        <quote :symbol='item.symbol'/>
      </div>
    </template>
    <template v-slot:content>
      <div>{{item.type}}</div>
      <div>{{date(item.date)}}</div>
      <div>{{float(item.quantity)}}</div>
      <div>{{float(item.price)}}</div>
    </template>
    <template v-slot:footer>
      <div>{{item.tags}}</div>
      <div>{{float(item.total)}}</div>
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
