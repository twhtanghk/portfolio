<template>
  <v-app>
    <drawer />
    <toolbar />
    <!--alert /-->
    <v-content>
      <v-component :is='content' />
    <v-content>
  </v-app>
</template>

<script lang='coffee'>
_ = require 'lodash'
Vue = require('vue').default

Vue.use require 'vuetify'
Vue.use require('vuelidate').default
eventBus = require('./eventBus').default

export default
  components:
    tx: require('./tx').default
    hold: require('./hold').default
    drawer: require('./drawer').default
    toolbar: require('./toolbar').default
    portfolio: require('./portfolio').default
    sector: require('./sector').default
  data: ->
    content: 'portfolio'
    eventBus: eventBus
  created: ->
    eventBus.$on 'content', (page) =>
      @content = page
</script>

<style lang='scss'>
@import url('https://fonts.googleapis.com/css?family=Roboto:300,400,500,700|Material+Icons');
@import '~vuetify/dist/vuetify.min.css';
@import '~plotly.js/src/css/style.scss';

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
