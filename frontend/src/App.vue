<template>
  <div id="app">
    <authForm :eventBus='eventBus' :oauth2='oauth2' />
    <model ref='portfolio' :eventBus='eventBus' baseUrl='http://172.23.0.3:1337/api/portfolio' />
    <b-table striped hover :items='collection' :fields='fields' />
  </div>
</template>

<script lang='coffee'>
Vue = require('vue').default
Vue.use require('bootstrap-vue').default
Vue.use require('vue.oauth2/src/plugin').default
Vue.use require('vue.model/src/plugin').default
eventBus = require('vue.oauth2/src/eventBus').default

format =
  date: (data) ->
    new Date(data).toLocaleDateString()
  float: (data) ->
    data.toFixed 2

module.exports =
  data: ->
    oauth2:
      url: 'https://app.ogcio.gov.hk/auth/oauth2/authorize/'
      client: 'testing'
      scope: 'User'
      response_type: 'token'
    eventBus: eventBus
    collection: []
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
  mounted: ->
    @$refs.portfolio.list()
      .then (res) =>
        @collection = _.map res, (item) ->
          item.total = item.quantity * item.price
          item
      .catch console.error
</script>
