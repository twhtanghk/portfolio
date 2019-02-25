module.exports = (ctx, next) ->
  ctx.request.body ?= {}
  ctx.request.body.createdBy = ctx.request.user._id
  await next()
