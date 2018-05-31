webpack = require 'webpack'

module.exports =
  outputDir: '../backend/dist'
  configureWebpack: (config) ->
    config.output.publicPath = ''
    config.plugins.push new webpack.EnvironmentPlugin [
      'CLIENT_ID'
      'AUTH_URL'
    ]
    config.module.rules.push
      test: /\.coffee$/
      use: [ 'coffee-loader' ]
    return
