<template>
  <v-list-tile-avatar>
    {{item.name}} {{item.symbol}}
  </v-list-tile-avatar>
  <v-list-tile-content>
    {{item.quantity}} {{item.price{}}
  </v-list-tile-content>
  <v-list-tile-action>
  </v-list-tile-action>
</template>

<script lang='coffee'>
export default
  props: [
    'item'
  ]
</script>
