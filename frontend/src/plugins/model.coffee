_ = require 'lodash'
oauth2 = require('./oauth2.coffee').default

class Model
  constructor: ({@baseUrl, @idAttribute, @api}) ->
    @idAttribute ?= 'id'
    @api ?= fetch
    @mw = [
      @json
      @methodOverride
      @req
      @res
      @error
    ]

  form: ({req,res} = {}) ->
    req = _.defaultsDeep req,
      headers:
        'Content-Type': 'application/x-www-form-urlencoded'
      if req.data?
        param = new URLSearchParams()
        for k, v of req.data
          param.set k, v
        if req.method == 'GET'
          req.url += "?#{param}"
        else
          req.body = param
      {req, res}

  json: ({req, res} = {}) =>
    req = _.defaultsDeep req,
      headers:
        'Content-Type': 'application/json'
    {req, res}

  methodOverride: ({req, res} = {}) ->
    req = _.defaultsDeep req,
      headers:
        'X-HTTP-Method-Override': req.method
    req.method = 'POST'
    if not ('body' of req and req.body instanceof FormData)
      req.body = JSON.stringify req.data
    {req, res}

  csrf: ({req, res}= {}) ->
    req = _.defaultsDeep req,
      headers:
        'x-csrf-token': document.cookie.match(/csrfToken=(.*);/)?[1]
    {req, res}

  req: ({req, res} = {}) ->
    res = await @api req.url, req
    {req, res}

  error: ({req, res} = {}) ->
    if res.status in [200..299]
      res = res.data
      {req , res}
    else if res.status == 401
      throw new Error "Unauthorized access"
    else
      throw new Error "#{res.statusText} #{JSON.stringify res.data}"

  res: ({req, res} = {}) ->
    {parse} = require 'content-type'
    {type} = parse res.headers.get 'Content-Type'
    switch type
      when 'text/plain'
        res.data = res.text()
      when 'application/json'
        res.data = await res.json()
        if Array.isArray res.data
          res.data = res.data.map @format
        else
          res.data = @format res.data
    {req, res}

  format: (data) ->
    data

  fetch: (opts = {}) ->
    opts = _.defaults opts, url: @baseUrl
    {req, res} = {}
    req = opts
    for i in @mw
      {req, res} = await i {req, res}
    res

  post: (opts = {}) ->
    res = await @fetch _.defaults opts, method: 'POST'

  get: (opts = {}) ->
    res = await @fetch _.defaults opts, method: 'GET'

  patch: (opts = {}) ->
    res = await @fetch _.defaults opts, method: 'PATCH'

  put: (opts = {}) ->
    res = await @fetch _.defaults opts, method: 'PUT'

  del: (opts = {}) ->
    res = await @fetch _.defaults opts, method: 'DELETE'

  iterPage: (opts = {}) ->
    skip = 0
    while true
      opts = _.defaultsDeep opts,
        data:
          skip: skip
      page = await @list opts
      skip += page.length
      if page.length == 0
        break
      yield page

  iterAll: (opts = {}) -> 
    for await page from @iterPage opts
      for i in page
        yield i

  count: (opts = {}) ->
    opts.url ?= "#{@baseUrl}/count"
    {count} = @get opts
    count

  upload: (opts = {}) ->
    opts = _.defaultsDeep opts,
      method: 'POST'
      url: "#{@baseUrl}/upload"
    formData = new FormData()
    for file in opts.files
      formData.append 'files', file
    opts.body = formData
    @fetch opts

  list: (opts = {}) ->
    await @get opts

  create: (opts = {}) ->
    await @post opts

  read: (opts = {}) ->
    opts = _.defaults opts, url: "#{@baseUrl}/#{opts.data[@idAttribute]}"
    await @get opts

  update: (opts = {}) ->
    opts = _.defaults opts, url: "#{@baseUrl}/#{opts.data[@idAttribute]}"
    await @put opts

  'delete': (opts = {}) ->
    opts = _.defaults opts, url: "#{@baseUrl}/#{opts.data[@idAttribute]}"
    await @del opts

class Portfolio extends Model
  date: (data, field) ->
    if data[field]?
      data[field] = new Date data[field]
    data
  format: (data) ->
    ['date', 'updatedAt', 'createdAt'].map (name) =>
      data = @date data, name
    if data.quantity? and data.price?
      _.extend data, total: data.quantity * data.price
    _.extend data,
      quote:
        curr: NaN
        high: NaN
        low: NaN
        last: NaN
        change: [NaN, NaN]
      details:
        pe: NaN
        pb: NaN
        dividend: [NaN, NaN, null, '']
      currTotal: null
      diffTotal: null
      diffPercent: null

export default
  Sector: new Model 
    baseUrl: "#{process.env.API_URL}/api/sector"
  Portfolio: new Portfolio
    baseUrl: "#{process.env.API_URL}/api/portfolio"
    api: oauth2.fetch
