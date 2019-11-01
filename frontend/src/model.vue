<script lang='coffee'>
Vue = require('vue').default
Vue.use require('vue.model/src/plugin').default
eventBus = require('./eventBus').default

export default
  Hsi: new Vue
    extends: Vue.component 'model'
    props:
      baseUrl:
        default: "#{process.env.API_URL}/api/hsi"
    methods:
      ad: ->
        await @get url: "#{@baseUrl}/ad"
  Portfolio: new Vue
    extends: Vue.component 'model'
    props:
      eventBus:
        default: ->
          eventBus
      baseUrl:
        default: "#{process.env.API_URL}/api/portfolio"
    methods:
      date: (data, field) ->
        if data[field]?
          data[field] = new Date data[field]
        data
      format: (data) ->
        ['date', 'updatedAt', 'createdAt'].map (name) =>
          data = @date data, name
        if data.quantity? and data.price?
          _.extend data, total: data.quantity * data.price
        _.extend data,
          quote:
            curr: NaN
            high: NaN
            low: NaN
            last: NaN
            change: [NaN, NaN]
          details:
            pe: NaN
            pb: NaN
            dividend: [NaN, NaN, null, '']
          currTotal: null
          diffTotal: null
          diffPercent: null
        data
</script>
