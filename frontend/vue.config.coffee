webpack = require 'webpack'

module.exports =
  compiler: true
  outputDir: '../backend/dist'
  configureWebpack: (config) ->
    if process.env.NODE_ENV == 'production'
      config.output.publicPath = './'
    config.plugins.push new webpack.EnvironmentPlugin [
      'CLIENT_ID'
      'AUTH_URL'
    ]
    return
