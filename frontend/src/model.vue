<script lang='coffee'>
Vue = require('vue').default
Vue.use require('vue.model/src/plugin').default
{eventBus} = require('jsOAuth2/frontend/src/lib').default

export default
  Portfolio: new Vue
    extends: Vue.component 'model'
    props:
      eventBus:
        default: ->
          eventBus
      baseUrl: 
        default: 'api/portfolio'
    methods:
      date: (data, field) ->
        if field?
          date[field] = new Date field
      format: (data) ->
        data = date data, 'date'
        data = date data, 'updatedAt'
        data = date data, 'createdAt'
        if data.quantity? and data.price?
          _.extend data, total: item.quantity * data.price
</script>
