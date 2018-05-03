<template>
  <div>
    <model ref='portfolio' :eventBus='eventBus' baseUrl='api/portfolio' />
    <v-context ref='menu'>
      <ul>
        <li @click='menuEdit'>Edit</li>
        <li @click='menuDel'>Delete</li>
      </ul>
    </v-context>
    <b-table striped hover :items='list' :fields='fields' @row-dblclicked='rowClick'>
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
        <td>
          <b-button size='sm' variant='primary' @click='add'>Add</b-button>
        </td>
        <td>
          <b-button size='sm' variant='secondary' @click.stop='cancel'>Cancel</b-button>
        </td>
      </template>
      <template slot='symbol' slot-scope='data'>
        <quote :symbol='data.value' v-if='data.index != showEdit' />
        <b-form-input v-model='tx.symbol' type='text'required v-if='data.index == showEdit' />
      </template>
      <template slot='type' slot-scope='data'>
        <template v-if='data.index != showEdit'>{{data.value}}</template>
        <b-form-select v-model='tx.type' :options='type' v-if='data.index == showEdit' />
      </template>
      <template slot='date' slot-scope='data'>
        <template v-if='data.index != showEdit'>{{data.value}}</template>
        <b-form-input v-model='tx.date' type='date' required v-if='data.index == showEdit' />
      </template>
      <template slot='quantity' slot-scope='data'>
        <template v-if='data.index != showEdit'>{{data.value}}</template>
        <b-form-input v-model='tx.quantity' type='number' required v-if='data.index == showEdit' />
      </template>
      <template slot='price' slot-scope='data'>
        <template v-if='data.index != showEdit'>{{data.value}}</template>
        <b-form-input v-model='tx.price' type='number' required v-if='data.index == showEdit' />
      </template>
      <template slot='total' slot-scope='data'>
        <template v-if='data.index != showEdit'>{{data.value}}</template>
        <b-button size='sm' variant='primary' @click.stop='update' v-if='data.index == showEdit'>
          Update
        </b-button>
        <b-button size='sm' variant='secondary' @click.stop='cancel' v-if='data.index == showEdit'>
          Cancel
        </b-button>
      </template>
      <template slot='tags' slot-scope='data'>
        <template v-if='data.index != showEdit'>{{data.value.join()}}</template>
        <mselect v-model='tx.tags' :options='alltags' :multiple='true' v-if='data.index == showEdit' />
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
    mselect: require('vue-multiselect').default
    vContext: require('vue-context').default
  props: [
    'tags'
  ]
  data: ->
    eventBus: require('vue.oauth2/src/eventBus').default
    fields: [
      { key: 'tags', sortable: true }
      { key: 'symbol', sortable: true }
      { key: 'name', sortable: true }
      { key: 'type', sortable: false }
      { key: 'date', sortable: true, formatter: format.date }
      { key: 'quantity', sortable: true }
      { key: 'price', sortable: false }
      { key: 'total', sortable: true, formatter: format.float }
    ]
    showAdd: false
    showEdit: null
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
    alltags: []
  methods:
    format: (item) ->
      _.extend item,
        date: new Date item.date
        updatedAt: new Date item.updatedAt
        createdAt: new Date item.createdAt
        total: item.quantity * item.price
    add: ->
      @list.unshift @format await @$refs.portfolio.create data: @tx
      @showAdd = false
    update: ->
      @tx.date = new Date @tx.date
      data = _.extend @list[@showEdit], @tx
      @list[@showEdit] = @format await @$refs.portfolio.update data: data
      @showEdit = null
    cancel: (event) ->
      @showAdd = false
      @showEdit = null
    rowClick: (data, index, event) ->
      @$refs.menu.open event, index
    menuEdit: (event) ->
      @showEdit = @$refs.menu.userData
      @tx.symbol = @list[@showEdit].symbol
      @tx.type = @list[@showEdit].type
      @tx.date = @list[@showEdit].date.toISOString().slice 0, 10
      @tx.quantity = @list[@showEdit].quantity
      @tx.price = @list[@showEdit].price
      @tx.tags = @list[@showEdit].tags
    menuDel: (event) ->
      index = @$refs.menu.userData
      await @$refs.portfolio.delete data: @list[index]
      @list.splice index, 1
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
            date: -1
            tags: 1
            symbol: 1
      if @tags.length != 0
        ret.data.or = @tags?.map (tag) ->
          tags:
            contains: tag
      ret
  watch:
    opts: ->
      @reload()
  mounted: ->
    @$refs.portfolio.read url: 'api/portfolio/tags'
      .then (res) =>
        for i in res
          @alltags.push i
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
