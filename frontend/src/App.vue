<template>
  <v-app>
    <authForm :eventBus='eventBus' :oauth2='oauth2' />
    <toolbar />
    <!--alert /-->
    <v-tabs fixed-tabs color='cyan' dark slider-color='yellow' @change='tabSelected'>
      <v-tab>
        Hold
      </v-tab>
      <v-tab>
        TX
      </v-tab> 
      <v-tab-item>
        <hold :tags='tags' />
      </v-tab-item>
      <v-tab-item>
        <tx :tags='tags' />
      </v-tab-item>
    </v-tabs>
  </v-app>
</template>

<script lang='coffee'>
_ = require 'lodash'
Vue = require('vue').default
Vue.use require 'vuetify'
Vue.use require('vuelidate').default
Vue.use require('bootstrap-vue').default
Vue.use require('vue.oauth2/src/plugin').default
{eventBus} = require('jsOAuth2/frontend/src/lib').default

export default
  components:
    tx: require('./tx').default
    hold: require('./hold').default
    toolbar: require('./toolbar').default
#    alert: require('jsOAuth2/frontend/src/alert').default
  data: ->
    oauth2:
      url: process.env.AUTH_URL
      client: process.env.CLIENT_ID
      scope: 'User'
      response_type: 'token'
    eventBus: eventBus
    tags: []
  methods:
    tagUpdated: (newtags) ->
      @tags.splice 0, @tags.length
      for i in newtags
        @tags.push i
    tabSelected: (selected) ->
      eventBus.$emit 'tab.selected', selected
</script>

<style lang='scss'>
@import url('https://fonts.googleapis.com/css?family=Roboto:300,400,500,700|Material+Icons');
@import '~vuetify/dist/vuetify.min.css';

#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  * {
    text-transform: none !important;
  }

  .portfolio-header div div {
    text-transform: capitalize !important;
  }
}
</style>
