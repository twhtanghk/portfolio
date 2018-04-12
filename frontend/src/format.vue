<template>
</template>

<script lang='coffee'>
module.exports =
  date: (data) ->
    if data?
      new Date(data).toLocaleDateString()
  float: (data) ->
    Number(data?.toFixed 2).toLocaleString()
</script>
