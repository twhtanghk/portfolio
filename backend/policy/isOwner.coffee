module.exports = (ctx, next) ->
  ctx.request.body ?= {}
  ctx.request.body.createdBy = ctx.req.user.email
  await next()
