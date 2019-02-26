d3 = require 'd3'
Model = require 'jsOAuth2/backend/model/model'

class Portfolio extends Model
  name: 'portfolio'

  attributes: [
    'symbol'
    'name'
    'type'
    'date'
    'quantity'
    'price'
    'notes'
    'createdBy'
    'tags'
  ]

  constructor: ->
    super()

  @isSell: (data) ->
    /^sell$/i.test data.type

  hold: (ctx, next) ->
    try
      collection = await @model.find ctx.request.body
      quantity = (item) ->
        if Portfolio.isSell item then -item.quantity else item.quantity
      ctx.response.body = await d3
        .nest()
        .key (item) ->
          item.symbol
        .rollup (group) ->
          name: group[0].name
          quantity: d3.sum group, quantity
          price: d3.sum group, (item) ->
            quantity(item) * item.price
          maxPrice: d3.max group, (item) ->
            if Portfolio.isSell item then 0 else item.price
        .entries collection
        .map (item) ->
          item.value.symbol = item.key
          item.value
        .filter (item) ->
          item.quantity != 0
    catch err
      ctx.throw 500, err.toString()
    
  tags: (ctx, next) ->
    try
      ret = []
      list = await @model.find ctx.request.body
      for i in list
        for tag in i.tags
          if tag not in ret
            ret.push tag
      ctx.response.body = ret
    catch err
      ctx.throw 500, err.toString()

module.exports = new Portfolio()
