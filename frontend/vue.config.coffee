webpack = require 'webpack'

module.exports =
  configureWebpack: (config) ->
    config.output.path = require('path').resolve __dirname, '../backend/dist'
    config.output.publicPath = './'
    config.plugins.push new webpack.EnvironmentPlugin [
      'CLIENT_ID'
      'AUTH_URL'
    ]
    return
