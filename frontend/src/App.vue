<template>
  <div id="app">
    <fab />
    <authForm :eventBus='eventBus' :oauth2='oauth2' />
    <model ref='portfolio' :eventBus='eventBus' baseUrl='api/portfolio' />
    <b-container>
      <mselect v-model='selected' :options='tags' :multiple='true' />
      <b-tabs>
        <b-tab title='Holding'>
          <hold :tags='selected' />
        </b-tab>
        <b-tab title='TX'>
          <portfolio :tags='selected' />
        </b-tab>
      </b-tabs>
    </b-container>
  </div>
</template>

<script lang='coffee'>
require 'vue-multiselect/dist/vue-multiselect.min.css'

d3 = require 'd3'
Vue = require('vue').default
Vue.use require('bootstrap-vue').default
Vue.use require('vue.oauth2/src/plugin').default
Vue.use require('vue.model/src/plugin').default
Vue.use require('vue-async-computed')
eventBus = require('vue.oauth2/src/eventBus').default
Vue.component 'upload', 
  extends: require('vue-fab/src/upload').default
  methods:
    change: (event) ->
      eventBus.$emit 'files.upload', event.target.files

module.exports =
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
    @$refs.portfolio.read 'tags'
      .then (res) =>
        for i in res
          @tags.push i
        @selected.push res[0] if res.length
</script>
