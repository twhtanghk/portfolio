Router = require 'koa-router'
router = new Router()
portfolio = require './model/portfolio'

isAuthenticated = require './policy/isAuthenticated'
isOwner = require './policy/isOwner'
setCreatedBy = require './policy/setCreatedBy'

module.exports = router
  .get '/api/portfolio', isAuthenticated, setCreatedBy, portfolio.find
  .get '/api/portfolio/hold', isAuthenticated, setCreatedBy, portfolio.hold
  .get '/api/portfolio/tags', isAuthenticated, portfolio.tags
  .post '/api/portfolio', isAuthenticated, setCreatedBy, portfolio.create
  .put '/api/portfolio/:id', isAuthenticated, isOwner, portfolio.update
  .delete '/api/portfolio/:id', isAuthenticated, isOwner, portfolio.destroy
