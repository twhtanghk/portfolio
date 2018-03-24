<template>
</template>

<script lang='coffee'>
module.exports =
  date: (data) ->
    if data?
      new Date(data).toLocaleDateString()
  float: (data) ->
    data?.toFixed 2
</script>
