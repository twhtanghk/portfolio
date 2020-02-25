_ = require 'lodash'

module.exports = (ctx, next) ->
  if ctx.request.body.date?
    iter = (res, value, key) ->
      res[key] = new Date value
    ctx.request.body.date = _.transform ctx.request.body.date, iter, {}
  await next()
