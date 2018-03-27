_ = require 'lodash'
yahoo = require 'yahoo-finance'

module.exports =
  yahoo:
    symbol: (num) ->
      "#{num}.HK"
    quote: yahoo.quote
    transform: (collection) ->
      yahoo = module.exports.yahoo
      if collection?.length == 0
        return collection
      yahoo
        .quote
          symbols: collection.map (item) ->
            yahoo.symbol item.symbol
        .then (list) ->
          collection.map (item) ->
            {price, summaryDetail} = list[yahoo.symbol item.symbol]
            _.extend item,
              marketPrice: price.marketPrice || price.regularMarketPrice
              dividend:
                rate: summaryDetail.dividendRate
                yield: summaryDetail.dividendYield
                exdate: summaryDetail.exDividendDate
                payoutRatio: summaryDetail.payoutRatio
              pe: summaryDetail.trailingPE
              marketcap: price.marketCap
