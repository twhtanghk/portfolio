module.exports =
  routes:
    'GET /api/portfolio/count':
      controller: 'PortfolioController'
      action: 'count'
    'GET /api/portfolio/onhold':
      controller: 'PortfolioController'
      action: 'findOnHold'
    'GET /api/portfolio/tags':
      controller: 'PortfolioController'
      action: 'tags'
    'POST /api/portfolio/import':
      controller: 'PortfolioController'
      action: 'import'
