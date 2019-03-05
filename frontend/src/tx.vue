<template>
  <v-container fluid>
    <v-layout column v-scroll='nextPage'>
      <v-flex xs12>
        <row class='portfolio-header'>
          <template v-slot:header>
            <div>name</div><div>symbol</div>
          </template>
          <template v-slot:content>
            <div>type</div>
            <div>date</div>
            <div>quantity</div>
            <div>price</div>
          </template>
          <template v-slot:footer>
            <div>tags</div>
            <div>total</div>
          </template>
        </row>
        <txitem v-for='item in list' :item='item' :key='item._id'/>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script lang='coffee'>
{eventBus} = require('jsOAuth2/frontend/src/lib').default
{Portfolio} = require('./model').default

export default
  components:
    txitem: require('./txitem').default
    row: require('./row').default
  props:
    tab: String
  data: ->
    list: []
    tags: []
    sort:
      date: 1
  methods:
    nextPage: ->
      if document.documentElement.scrollTop + window.innerHeight == document.documentElement.offsetHeight
        @load @list.length
    load: (skip = 0) ->
      if skip == 0
        @list.splice 0, @list.length
      try
        data =
          sort: @sort
          skip: skip
        if @tags.length
          data.tags = $in: @tags
        res = await Portfolio.get data: data
        for i in res
          @list.push i
      catch err
        console.error err.toString()
  watch:
    tab: (newtab, oldtab) ->
      if newtab == 'tx'
        @load()
    tags: (newtags, oldtags) ->
      if @tab == 'tx'
        @load()
  created: ->
    eventBus
      .$on 'tags.changed', ({tags}) =>
        @tags.splice 0, @tags.length
        for i in tags
          @tags.push i
</script>
