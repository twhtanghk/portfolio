<template>
  <row>
    <template v-slot:header>
      <div>{{item.name}}</div>
      <div>
        <quote :symbol='item.symbol'/>
      </div>
    </template>
    <template v-slot:content>
      <div>{{item.quantity}}</div>
      <div>{{item.price}}</div>
    </template>
    <template v-slot:footer>
    </template>
  </row>
</template>

<script lang='coffee'>
export default
  props: [
    'item'
  ]
  components:
    row: require('./row').default
    quote: require('./quote').default
</script>
