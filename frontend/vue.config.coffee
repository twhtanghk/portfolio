module.exports =
  configureWebpack: (config) ->
    config.output.path = require('path').resolve __dirname, '../backend/dist'
    return
