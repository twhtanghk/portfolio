module.exports =
  policies:
    PortfolioController:
      '*': false
      find: ['isAuth']
      create: ['isAuth', 'setCreatedBy']
      update: ['isAuth', 'isOwner']
      destroy: ['isAuth', 'isOwner']
