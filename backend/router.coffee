Router = require 'koa-router'
router = new Router()
portfolio = require './model/portfolio'
  .actions [
    'find'
    'hold'
    'tags'
    'create'
    'update'
    'destroy'
  ]
hsi = require './model/hsi'
  .actions [
    'find'
    'ad'
  ]

isAuthenticated = require './policy/isAuthenticated'
isOwner = require './policy/isOwner'
setCreatedBy = require './policy/setCreatedBy'

module.exports = router
  .get '/api/portfolio', isAuthenticated, setCreatedBy, portfolio.find
  .get '/api/portfolio/hold', isAuthenticated, setCreatedBy, portfolio.hold
  .get '/api/portfolio/tags', isAuthenticated, setCreatedBy, portfolio.tags
  .post '/api/portfolio', isAuthenticated, setCreatedBy, portfolio.create
  .put '/api/portfolio/:id', isAuthenticated, isOwner, portfolio.update
  .delete '/api/portfolio/:id', isAuthenticated, isOwner, portfolio.destroy
  .get '/api/hsi', hsi.find
  .get '/api/hsi/ad', hsi.ad
