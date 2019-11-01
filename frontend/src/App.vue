<template>
  <v-app>
    <authForm :eventBus='eventBus' :oauth2='oauth2' />
    <drawer />
    <toolbar />
    <!--alert /-->
    <v-content>
      <v-tabs fixed-tabs color='cyan' slider-color='yellow' @change='change'>
        <v-tab>
          Hold
        </v-tab>
        <v-tab>
          TX
        </v-tab> 
        <v-tab-item>
          <hold :tab='tab'/>
        </v-tab-item>
        <v-tab-item>
          <tx :tab='tab'/>
        </v-tab-item>
      </v-tabs>
    <v-content>
  </v-app>
</template>

<script lang='coffee'>
_ = require 'lodash'
Vue = require('vue').default
Vue.use require 'vuetify'
Vue.use require('vuelidate').default
Vue.use require('bootstrap-vue').default
Vue.use require('vue.oauth2/src/plugin').default
eventBus = require('./eventBus').default

export default
  components:
    tx: require('./tx').default
    hold: require('./hold').default
    drawer: require('./drawer').default
    toolbar: require('./toolbar').default
  data: ->
    oauth2:
      url: process.env.AUTH_URL
      client: process.env.CLIENT_ID
      scope: 'User'
      response_type: 'token'
    eventBus: eventBus
    tab: 'hold'
  methods:
    change: (tab) ->
      @tab = ['hold', 'tx'][tab]
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

  .odd {
    background-color: #f2f2f2;
  }

  .profit {
    color: green;
  }

  .loss {
    color: red;
  }
}
</style>
