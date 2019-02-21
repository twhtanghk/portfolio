{EnvironmentPlugin} = require 'webpack'
CompressionWebpackPlugin = require 'compression-webpack-plugin'

module.exports =
  publicPath: './'
  outputDir: '../backend/dist'
  lintOnSave: false
  devServer:
    host: '0.0.0.0'
    disableHostCheck: true
  configureWebpack: (config) ->
    config.output.publicPath = ''
    config.plugins.push new EnvironmentPlugin [
      'CLIENT_ID'
      'AUTH_URL'
    ]
    config.plugins.push new CompressionWebpackPlugin
      deleteOriginalAssets: true
      include: [
        /\.ico$/
        /\.html$/
        /\.js$/
        /\.css$/
        /\.map$/
      ]
    config.module.rules.push
      test: /\.coffee$/
      use: [
        'babel-loader'
        'coffee-loader'
      ]
    return
