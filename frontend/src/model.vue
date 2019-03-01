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
        if data[field]?
          data[field] = new Date field
        data
      format: (data) ->
        ['date', 'updatedAt', 'createdAt'].map (name) =>
          data = @date data, name
        if data.quantity? and data.price?
          _.extend data, total: data.quantity * data.price
        data
</script>
