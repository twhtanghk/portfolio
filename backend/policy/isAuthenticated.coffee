module.exports = (ctx, next) ->
  if ctx.isAuthenticated()
    return await next()
