<template>
  <fab :actions='actions' bg-color='#007bff' @create='create' />
</template>

<script lang='coffee'>
eventBus = require('vue.oauth2/src/eventBus').default
Vue = require('vue').default
Vue.component 'upload',
  extends: require('vue-fab/src/upload').default
  methods:
    change: (event) ->
      eventBus.$emit 'files.upload', event.target.files

module.exports =
  components:
    fab: require('vue-fab').default
  props: [
    'eventBus'
  ]
  data: ->
    actions: [
      { name: 'create', tooltip: 'Create', icon: 'add' }
      { name: 'upload', tooltip: 'Upload', 'icon-component': 'upload' }
    ]
  methods:
    create: ->
      @eventBus.$emit 'tx.form'
</script>
