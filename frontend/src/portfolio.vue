<template>
  <div>
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
        <b-form-input v-model='tx.symbol' type='text' required v-if='data.index == showEdit' />
      </template>
      <template slot='type' slot-scope='data'>
        <template v-if='data.index != showEdit'>{{data.value}}</template>
        <b-form-select v-model='tx.type' :options='type' v-if='data.index == showEdit' />
      </template>
      <template slot='name' slot-scope='data'>
        <template v-if='data.index != showEdit'>{{data.value}}</template>
        <b-form-input v-model='tx.name' type='text' v-if='data.index == showEdit' />
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
{Portfolio} = require('./model').default
{eventBus} = require('jsOAuth2/frontend/src/lib').default

format = require('./format').default

export default
  components:
    quote: require('./quote').default
    mselect: require('vue-multiselect').default
    vContext: require('vue-context').default
  props: [
    'tags'
  ]
  data: ->
    eventBus: eventBus
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
    add: ->
      @list.unshift await Portfolio.create data: @tx
      @showAdd = false
    update: ->
      @tx.date = new Date @tx.date
      index = @list.findIndex (data) =>
        @tx.id == data.id
      _.extend @list[index], @tx
      _.extend @list[index], await Portfolio.update data: @list[index]
      @showEdit = null
    cancel: (event) ->
      @showAdd = false
      @showEdit = null
    rowClick: (data, index, event) ->
      @$refs.menu.open event,
        index: index
        data: data
    menuEdit: (event) ->
      {index, data} = @$refs.menu.userData
      @showEdit = index
      @tx.id = data.id
      @tx.symbol = data.symbol
      @tx.type = data.type
      @tx.date = data.date?.toISOString().slice 0, 10
      @tx.quantity = data.quantity
      @tx.price = data.price
      @tx.tags = data.tags
    menuDel: (event) ->
      {index, data} = @$refs.menu.userData
      await @$refs.portfolio.delete data: data
      index = @list.findIndex (tx) ->
        tx.id == data.id
      @list.splice index, 1
    reload: ->
      @list.splice 0
      opts = @opts
      for await value from Portfolio.iterAll opts
         @list.push value
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
    Portfolio.read url: 'api/portfolio/tags'
      .then (res) =>
        for i in res
          @alltags.push i
    eventBus.$on 'files.upload', (files) =>
      await @$refs.portfolio?.upload files: files
    eventBus.$on 'tx.add', =>
      @showAdd = true
</script>

<style scoped>
td, th {
  vertical-align: middle;
}
</style>
