module.exports =
  policies:
    PortfolioController:
      '*': false
      count: ['isAuth', 'isOwner']
      findOnHold: ['isAuth', 'isOwner']
      tags: ['isAuth', 'isOwner']
      find: ['isAuth', 'isOwner']
      create: ['isAuth', 'setCreatedBy']
      update: ['isAuth', 'isOwner']
      destroy: ['isAuth', 'isOwner']
