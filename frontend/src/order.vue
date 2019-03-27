<template>
  <v-btn-toggle v-model='selected' @change='sort'>
    <v-btn flat>
      <v-icon>
        arrow_drop_up
      </v-icon>
    </v-btn>
    <v-btn flat>
      <v-icon>
        arrow_drop_down
      </v-icon>
    </v-btn>
  </v-btn-toggle>
</template>

<script lang='coffee'>
export default
  data: ->
    selected: null
  methods:
    sort: ->
      if @selected?
        @$emit 'sort', if @selected == 0 then 1 else -1
      else
        @$emit 'sort', 0
</script>

<style lang='scss' scoped>
.v-btn {
  padding: 0;
}
</style>
