d3 = require 'd3'

symbol =
  yahoo: (symbol) ->
    "#{symbol}.HK"

module.exports =
  tablesName: 'portfolio'
  schema: true
  attributes:
    symbol:
      type: 'string'
      required: true
    name:
      type: 'string'
    type:
      type: 'string'
    date:
      type: 'date'
    quantity:
      type: 'float'
    price:
      type: 'float'
    notes:
      type: 'string'
    createdBy:
      model: 'user'
      required: true
    tags:
      type: 'array'
  findOnHold: (cond) ->
    @find()
      .where cond
      .then (collection) ->
        quantity = (item) ->
          if /^sell$/i.test item.type then -item.quantity else item.quantity
        d3
          .nest()
          .key (item) ->
            item.symbol
          .rollup (group) ->
            name: group[0].name
            quantity: d3.sum group, quantity
            price: d3.sum group, (item) ->
              quantity(item) * item.price
          .entries collection
          .map (item) ->
            item.value.symbol = item.key
            item.value
          .filter (item) ->
            item.quantity != 0
      .then sails.config.yahoo.transform 
