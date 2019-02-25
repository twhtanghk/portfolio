Model = require 'jsOAuth2/backend/model/model'

class User extend Model
  name: 'user'

  attributes: [
    'email'
  ]

  constructor: ->
    super()

    @model.createIndex {email: 1}, {unique: true}

module.exports =
  new User()
    .actions()
