<template>
  <v-app>
    <authForm :eventBus='eventBus' :oauth2='oauth2' />
    <toolbar />
    <!--alert /-->
    <v-tabs centered color='cyan' dark icons-and-text>
      <v-tabs-slider color='yellow' />
      <v-tab>
        Hold
        <v-icon></v-icon>
      </v-tab>
      <v-tab>
        TX
        <v-icon></v-icon>
      </v-tab> 
      <v-tab-item>
        <hold />
      </v-tab-item>
      <v-tab-item>
        <portfolio />
      </v-tab-item>
    </v-tabs>
  </v-app>
</template>

<script lang='coffee'>
_ = require 'lodash'
Vue = require('vue').default
Vue.use require 'vuetify'
Vue.use require('vuelidate').default
Vue.use require('vue.oauth2/src/plugin').default
{eventBus} = require('jsOAuth2/frontend/src/lib').default

export default
  components:
    portfolio: require('./portfolio').default
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
}
</style>
