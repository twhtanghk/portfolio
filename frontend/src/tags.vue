<template>
  <v-select
    v-model='selected'
    :items='tags'
    label='Tags'
    @change='change'
    solo hide-details single-line chips multiple />
</template>

<script lang='coffee'>
{Portfolio} = require('./model').default
{eventBus} = require('jsOAuth2/frontend/src/lib').default

export default
  data: ->
    tags: []
    selected: []
  methods:
    change: ->
      eventBus.$emit 'tags.changed', tags: @selected
  created: ->
    try
      res = await Portfolio.get url: 'api/portfolio/tags'
      for i in res
        @tags.push i
      @selected.push res[0] if res.length
      @change()
    catch err
      console.error err.toString()
</script>
