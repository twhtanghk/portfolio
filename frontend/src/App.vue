<template>
  <div id="app">
    <authForm :eventBus='eventBus' :oauth2='oauth2' />
    <model ref='portfolio' :eventBus='eventBus' baseUrl='http://172.23.0.3:1337/api/portfolio' />
    <b-container>
      <b-row>
        <b-col>
          <mselect v-model='selected' :options='tags' :multiple='true' />
        </b-col>
      </b-row>
      <b-row>
        <b-col>
          <onhold :tags='selected' />
        </b-col>
        <b-col>
          <portfolio :tags='selected' />
        </b-col>
      </b-row>
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

module.exports =
  components:
    portfolio: require('./portfolio').default
    onhold: require('./onhold').default
    mselect: require('vue-multiselect').default
  data: ->
    oauth2:
      url: 'https://app.ogcio.gov.hk/auth/oauth2/authorize/'
      client: 'testing'
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
</script>
