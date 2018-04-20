<template>
  <fab :actions='actions' bg-color='#007bff' />
</template>

<script lang='coffee'>
upload = require('vue-fab/src/upload').default

module.exports =
  components:
    fab: require('vue-fab').default
  data: ->
    actions: [
      { name: 'upload', tooltip: 'Upload', 'icon-component': upload }
    ]
</script>
