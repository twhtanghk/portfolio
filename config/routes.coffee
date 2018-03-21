module.exports =
  routes:
    'GET /api/portfolio/tags':
      controller: 'PortfolioController'
      action: 'tags'
    'GET /api/portfolio':
      controller: 'PortfolioController'
      action: 'find'
    'POST /api/portfolio':
      controller: 'PortfolioController'
      action: 'create'
    'PUT /api/portfolio/:id':
      controller: 'PortfolioController'
      action: 'update'
    'DELETE /api/portfolio/:id':
      controller: 'PortfolioController'
      action: 'destroy'
