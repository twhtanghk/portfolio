<template>
  <div id="app">
    <fab :eventBus='eventBus' />
    <authForm :eventBus='eventBus' :oauth2='oauth2' />
    <model ref='portfolio' :eventBus='eventBus' baseUrl='api/portfolio' />
      <mselect v-model='selected' :options='tags' :multiple='true' />
      <b-tabs>
        <b-tab title='Holding'>
          <hold :tags='selected' />
        </b-tab>
        <b-tab title='TX'>
          <portfolio :tags='selected' />
        </b-tab>
      </b-tabs>
  </div>
</template>

<script lang='coffee'>
require 'vue-multiselect/dist/vue-multiselect.min.css'

_ = require 'lodash'
d3 = require 'd3'
Vue = require('vue').default
Vue.use require('bootstrap-vue').default
Vue.use require('vue.oauth2/src/plugin').default
Vue.use require('vue-async-computed')
eventBus = require('vue.oauth2/src/eventBus').default
Vue.component 'model', 
  extends: require('vue.model/src/model').default
  methods:
    format: (item) ->
      if item.date?
        _.extend item, date: new Date item.date
      if item.updatedAt?
        _.extend item, updatedAt: new Date item.updatedAt
      if item.createdAt?
        _.extend item, createdAt: new Date item.createdAt
      if item.quantity? and item.price?
        _.extend item, total: item.quantity * item.price
      item

export default
  components:
    portfolio: require('./portfolio').default
    hold: require('./hold').default
    mselect: require('vue-multiselect').default
    fab: require('./fab').default
  data: ->
    oauth2:
      url: process.env.AUTH_URL
      client: process.env.CLIENT_ID
      scope: 'User'
      response_type: 'token'
    eventBus: eventBus
    tags: []
    selected: []
  created: ->
    eventBus.$emit 'login'
  mounted: ->
    @$refs.portfolio.get url: 'api/portfolio/tags'
      .then (res) =>
        for i in res
          @tags.push i
        @selected.push res[0] if res.length
</script>
