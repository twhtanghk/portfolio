module.exports =
  routes:
    'GET /api/portfolio/count':
      controller: 'PortfolioController'
      action: 'count'
    'GET /api/portfolio/hold':
      controller: 'PortfolioController'
      action: 'findHold'
    'GET /api/portfolio/tags':
      controller: 'PortfolioController'
      action: 'tags'
    'POST /api/portfolio/upload':
      controller: 'PortfolioController'
      action: 'import'
