{fetch} = require('model/oauth2.coffee').default
{Model} = require('model').default

class Portfolio extends Model
  date: (data, field) ->
    if data[field]?
      data[field] = new Date data[field]
    data
  format: (data) ->
    if 'string' == typeof data
      return data
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

a = new Portfolio
  baseUrl: "#{process.env.API_URL}/api/portfolio"
  api: fetch

export default
  Sector: new Model
    baseUrl: "#{process.env.API_URL}/api/sector"
  Portfolio: new Portfolio
    baseUrl: "#{process.env.API_URL}/api/portfolio"
    api: fetch
