_ = require 'lodash'
d3 = require 'd3'
Model = require 'koamodel'

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

  create: (ctx, next) ->
    ctx.request.body.date = new Date ctx.request.body.date
    super ctx, next

  @isSell: (data) ->
    /^sell$/i.test data.type

  hold: (ctx, next) ->
    try
      optsField = ['limit', 'skip', 'sort']
      opts = _.pick ctx.request.body, optsField
      query = _.omit ctx.request.body, optsField
      collection = await @model.find query, opts
      quantity = (item) ->
        if Portfolio.isSell item then -item.quantity else item.quantity
      ctx.response.body = d3
        .nest()
        .key (item) ->
          item.symbol
        .rollup (group) ->
          txBuy = _.filter group, (item) ->
            (new RegExp 'buy', 'i').test item.type
          lastBuy = _.maxBy txBuy, 'createdAt'
          share = d3.sum group, quantity
          total = d3.sum group, (item) ->
            quantity(item) * item.price
          return 
            name: group[0].name
            quantity: share
            price: lastBuy?.price
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
        if i.tags?
          for tag in i.tags
            if tag not in ret
              ret.push tag
      ctx.response.body = ret
    catch err
      ctx.throw 500, err.toString()

module.exports = new Portfolio()
