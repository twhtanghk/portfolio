module.exports =
  policies:
    PortfolioController:
      '*': false
      count: ['isAuth']
      tags: ['isAuth']
      find: ['isAuth', 'isOwner']
      create: ['isAuth', 'setCreatedBy']
      update: ['isAuth', 'isOwner']
      destroy: ['isAuth', 'isOwner']
