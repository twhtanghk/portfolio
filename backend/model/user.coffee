Model = require 'koamodel'

class User extends Model
  name: 'user'

  attributes: [
    'email'
  ]

  constructor: ->
    super()

    @model.createIndex {email: 1}, {unique: true}

module.exports = new User()
