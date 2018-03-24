<template>
  <div id="app">
    <authForm :eventBus='eventBus' :oauth2='oauth2' />
    <model ref='portfolio' :eventBus='eventBus' baseUrl='http://172.22.0.3:1337/api/portfolio' />
    <b-container>
      <b-row>
        <b-col>
          <portfolio :collection='collection' />
        </b-col>
        <b-col>
          <onhold :collection='collection' />
        </b-col>
      </b-row>
    </b-container>
  </div>
</template>

<script lang='coffee'>
d3 = require 'd3'
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
  components:
    portfolio: require('./portfolio').default
    onhold: require('./onhold').default
  data: ->
    oauth2:
      url: 'https://app.ogcio.gov.hk/auth/oauth2/authorize/'
      client: 'testing'
      scope: 'User'
      response_type: 'token'
    eventBus: eventBus
    collection: []
  mounted: ->
    gen = await @$refs.portfolio.listAll
      data:
        type:
          '!': null
        tags:
          contains: 'cheung'
        sort:
          symbol: 1
          date: 1
          tags: 1
    do =>
      {next} = gen()
      while true
        {done, value} = await next @collection.length
        break if done
        for i in value
          @collection.push i
</script>
