<template>
  <b-modal ref='create' hide-footer='true'>
    <b-form ref='createForm' @submit='create'>
      <div>{{ tx.data }}</div>
      <b-form-group label='Symbol' label-for='symbol'>
        <b-form-input id='symbol' type='text' v-model='tx.symbol' required placeholder='0001' />
      </b-form-group>
      <b-form-group label='Name' label-for='name'>
        <b-form-input id='name' type='text' v-model='tx.name' required placeholder='長和' />
      </b-form-group>
      <b-form-group label='TX Type' label-for='type'>
        <b-form-input id='type' type='text' v-model='tx.type' />
      </b-form-group>
      <b-form-group label='Date' label-for='date'>
        <b-form-input id='date' type='date' v-model='tx.date' />
      </b-form-group>
      <b-form-group label='Quantity' label-for='quantity'>
        <b-form-input id='quantity' type='number' v-model='tx.quantity' />
      </b-form-group>
      <b-form-group label='Price' label-for='price'>
        <b-form-input id='price' type='number' v-model='tx.price' />
      </b-form-group>
      <b-form-group label='Notes' label-for='notes'>
        <b-form-input id='notes' type='text' v-model='tx.notes' />
      </b-form-group>
      <b-button type='submit' variant='primary'>Create</b-button>
      <b-button type='cancel' variant='secondary'>Cancel</b-button>
    </b-form>
  </b-modal>
</template>

<script lang='coffee'>
module.exports =
  props: [
    'eventBus'
  ]
  data: ->
    tx:
      symbol: ''
      name: ''
      type: 'Buy'
      date: new Date().toISOString().slice(0, 10)
      quantity: 0
      price: 0
      notes: ''
  methods:
    create: (event) ->
      event.preventDefault()
      @eventBus.$emit 'tx.create', @tx
      @$refs.create.hide()
  mounted: ->
    @eventBus.$on 'tx.form', =>
      @$refs.create.show() 
</script>
