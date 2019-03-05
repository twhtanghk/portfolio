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
      <div>{{item.date ? item.date.toLocaleDateString() : ''}}</div>
      <div>{{item.quantity}}</div>
      <div>{{item.price}}</div>
    </template>
    <template v-slot:footer>
      <div>{{item.tags}}</div>
      <div>{{item.total}}</div>
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
