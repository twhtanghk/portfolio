<template>
  <div>
    <model ref='portfolio' :eventBus='eventBus' baseUrl='api/portfolio' />
    <b-table striped hover :items='list' :fields='fields'>
      <template slot='symbol' slot-scope='data'>
        <quote :symbol='data.value' />
      </template>
    </b-table>
  </div>
</template>

<script lang='coffee'>
Vue = require('vue').default
Vue.use require('bootstrap-vue').default

format = require('./format').default

module.exports =
  components:
    quote: require('./quote').default
  props: [
    'tags'
  ]
  data: ->
    eventBus: require('vue.oauth2/src/eventBus').default
    fields: [
      { key: 'symbol', sortable: true }
      { key: 'name', sortable: true }
      { key: 'type', sortable: false }
      { key: 'date', sortable: true, formatter: format.date }
      { key: 'quantity', sortable: true }
      { key: 'price', sortable: false }
      { key: 'total', sortable: true, formatter: format.float }
      { key: 'tags', sortable: true }
    ]
    list: []
  methods:
    format: (item) ->
      _.extend item, total: item.quantity * item.price
    reload: ->
      @list.splice 0
      opts = @opts
      gen = @$refs.portfolio?.listAll opts
      if gen?
        {next} = gen()
        while true
          {done, value} = await next @list.length
          break if done
          for i in value
            @list.push @format i
  computed:
    opts: ->
      ret = 
        data:
          type:
            '!': null
          sort:
            symbol: 1
            date: 1
            tags: 1
      if @tags.length != 0
        ret.data.or = @tags?.map (tag) ->
          tags:
            contains: tag
      ret
  watch:
    opts: ->
      @reload()
  mounted: ->
    @eventBus.$on 'files.upload', (files) =>
      await @$refs.portfolio?.upload files: files
    @eventBus.$on 'tx.create', (data) =>
      data.tags = @tags
      @list.push await @$refs.portfolio.create data: data
</script>
