Vue = require('vue').default
Vue.use require('vue.oauth2/src/plugin').default
{eventBus} = require('jsOAuth2/frontend/src/lib').default

Vue.config.devtools = true
Vue.config.productionTip = false

new Vue
  el: '#app'
  render: (h) ->
    h 'authForm', props: eventBus: eventBus
