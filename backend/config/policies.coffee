module.exports =
  policies:
    PortfolioController:
      '*': false
      tags: ['isAuth']
      find: ['isAuth', 'isOwner']
      create: ['isAuth', 'setCreatedBy']
      update: ['isAuth', 'isOwner']
      destroy: ['isAuth', 'isOwner']
