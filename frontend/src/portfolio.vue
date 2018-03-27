<template>
  <div>
    <model ref='portfolio' :eventBus='eventBus' baseUrl='http://172.23.0.3:1337/api/portfolio' />
    <b-table striped hover :items='list' :fields='fields'>
      <template slot='symbol' slot-scope='data'>
        <quote :symbol='data.value'
      </template>
    </b-table>
  </div>
</template>

<script lang='coffee'>
Vue = require('vue').default
Vue.use require('bootstrap-vue').default

format = require('./format').default

module.exports =
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
  mounted: ->
    gen = await @$refs.portfolio.listAll
      data:
        type:
          '!': null
        sort:
          symbol: 1
          date: 1
          tags: 1
    do =>
      {next} = gen()
      while true
        {done, value} = await next @list.length
        break if done
        for i in value
          @list.push i
</script>
