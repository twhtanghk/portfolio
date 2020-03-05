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

  @isBuy: (data) ->
    /^buy$/i.test data.type

  @isSell: (data) ->
    /^sell$/i.test data.type

  @quantity: (tx) ->
    if Portfolio.isSell tx then -tx.quantity else tx.quantity

  @total: (txlist) ->
    quantity: d3.sum txlist, (item) ->
      Portfolio.quantity(item)
    price: d3.sum txlist, (item) ->
      Portfolio.quantity(item) * item.price

  @avg: (txlist) ->
    {quantity, price} = Portfolio.total txlist 
    price / quantity
    
  hold: (ctx, next) ->
    optsField = ['limit', 'skip', 'sort']
    opts = _.pick ctx.request.body, optsField
    query = _.omit ctx.request.body, optsField
    collection = await @model.find query, opts
    ctx.response.body = d3
      .nest()
      .key (item) ->
        item.symbol
      .rollup (group) ->
        {quantity, price} = Portfolio.total group
        txBuy = _.filter group, (tx) ->
            Portfolio.isBuy tx
        return 
          name: group[0].name
          quantity: quantity
          price: _.maxBy(txBuy, 'date')?.price
          avg:  Portfolio.avg group
          maxPrice: d3.max group, (item) ->
            if Portfolio.isSell item then 0 else item.price
      .entries collection
      .map (item) ->
        item.value.symbol = item.key
        item.value
      .filter (item) ->
        item.quantity != 0
    
  tags: (ctx, next) ->
    ret = []
    list = await @model.find ctx.request.body
    for i in list
      if i.tags?
        for tag in i.tags
          if tag not in ret
            ret.push tag
    ctx.response.body = ret

module.exports = new Portfolio()
