<template>
  <div>{{ ad }}</div>
</template>

<script lang='coffee'>
{Hsi} = require('./model').default

export default
  data: ->
    ad: ''
  created: ->
    @ad = JSON.stringify await Hsi.ad()   
</script>
