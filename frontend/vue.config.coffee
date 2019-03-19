{EnvironmentPlugin} = require 'webpack'
CompressionWebpackPlugin = require 'compression-webpack-plugin'

module.exports =
  publicPath: '.'
  outputDir: '../backend/dist'
  configureWebpack: (config) ->
    if process.env.NODE_ENV == 'production'
      config.plugins.push new CompressionWebpackPlugin
        deleteOriginalAssets: true
        include: [
          /\.ico$/
          /\.html$/
          /\.js$/
          /\.css$/
          /\.map$/
        ]
      process.env.API_URL = '.'
    config.plugins.push new EnvironmentPlugin [
      'CLIENT_ID'
      'AUTH_URL'
      'API_URL'
      'MQTTURL'
      'MQTTUSER'
      'MQTTTOPIC'
    ]
    config.module.rules.push
      test: /\.coffee$/
      use: [
        'babel-loader'
        'coffee-loader'
      ]
    return
