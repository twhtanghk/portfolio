module.exports =
  http:
    middleware:
      order: [
        'bodyParser'
        'compress'
        'router'
        'www'
        'favicon'
        '404'
        '500'
      ]
