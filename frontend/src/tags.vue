<template>
  <mselect v-model='list' :options='list' :multiple='true' />
</template>

<script lang='coffee'>
require 'vue-multiselect/dist/vue-multiselect.min.css'

module.exports =
  components:
    mselect: require('vue-multiselect').default
  props: [
    'list'
  ]
</script>
