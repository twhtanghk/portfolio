module.exports =
  policies:
    PortfolioController:
      '*': false
      find: ['isAuth']
      create: ['isAuth']
      update: ['isAuth', 'isOwner']
      destroy: ['isAuth', 'isOwner']
