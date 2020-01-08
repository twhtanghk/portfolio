<script lang='coffee'>
export default
  date: (data) ->
    if data?
      new Date(data).toLocaleDateString()
  float: (data) ->
    if data?
      Number(data?.toFixed 2).toLocaleString()
</script>
