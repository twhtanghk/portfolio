<template>
  <v-menu
    v-model='menu'
    :close-on-content-click="false"
    :nudge-right="40"
    transition="scale-transition"
    offset-y
    min-width="290px">
    <template v-slot:activator="{ on }">
      <v-text-field
        v-model="value"
        prepend-icon="event"
        :label='label'
        readonly
        clearable
        v-on="on"
        @click:clear='clear' />
    </template>
  <v-date-picker v-model="value" no-title @input="input"/>
</template>

<script lang='coffee'>
export default
  props: [ 
    'label'
    'value' 
  ]
  data: ->
    menu: false
  methods:
    input: ->
      @$emit 'update:value', @value
      @menu = false
    clear: ->
      @$emit 'update:value', null
</script>
