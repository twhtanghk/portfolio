<template>
  <div>
    <model ref='portfolio' :eventBus='eventBus' baseUrl='api/portfolio' />
    <b-table striped hover :items='list' :fields='fields'>
      <template slot='top-row' slot-scope='data' v-if='showAdd'>
        <td>
          <b-form-input v-model='tx.symbol' type='text' required placeholder='0001' />
        </td>
        <td>
        </td>
        <td>
          <b-form-select v-model='tx.type' :options='type' />
        </td>
        <td>
          <b-form-input v-model='tx.date' type='date' required />
        </td>
        <td>
          <b-form-input v-model='tx.quantity' type='number' required />
        </td>
        <td>
          <b-form-input v-model='tx.price' type='number' required />
        </td>
        <td colspan='2'>
          <b-button size='sm' variant='primary' @click='add'>Add</b-button>
          <b-button size='sm' variant='secondary' @click='cancel'>Cancel</b-button>
        </td>
      </template>
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
    showAdd: false
    list: []
    tx:
      symbol: ''
      type: 'Buy'
      date: new Date().toISOString().slice(0, 10)
      quantity: 0
      price: 0
      notes: ''
      tags: @tags
    type: [
      { value: 'Buy', text: 'Buy' }
      { value: 'Sell', text: 'Sell' }
      { value: 'Bonus', text: 'Bonus' }
    ]
  methods:
    format: (item) ->
      _.extend item, total: item.quantity * item.price
    add: ->
      @list.unshift @format await @$refs.portfolio.create data: @tx
      @showAdd = false
    edit: ->
      console.log arguments
    del: ->
      console.log arguments
    cancel: ->
      @showAdd = false
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
    @eventBus.$on 'tx.add', =>
      @showAdd = true
</script>

<style scoped>
td, th {
  vertical-align: middle;
}
</style>
