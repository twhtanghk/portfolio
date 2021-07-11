# portfolio

```
mqtt stock/#:
  chart:
    monitor:
      topic: stock
      data:
        action: subscribe
        data: [code, ...]
    response:
      topic: stock/yahoo
      data:
        src: yahoo
        symbol: stock code
        quote: ...
        indicators:
          c/s: number
          s/m: number
          m/l: number
          max: number
          min: number
          open: number
          close: number
          ema20: number
          ema60: number
          ema120: number
          diff:
            up: percentage
            down: percentage
          date:
            start: date
            end: date
  hkex:
    monitor:
      topic: stock
      data:
        action: subscribe
        data: [code, ...]
    response:
      topic: stock/hkex    
      data:
        src: hkex
        symbol: stock code
        name: stock name
  aastocks: 
    monitor:
      topic: stock
      data:
        action: subscribe
        data: [code, ...]
    respnose:
      topic: stock/aastocks
      data:
        src: aastocks
        symbol: stock code
        name: stock name
        quote: ...
        history: ...
        details:
          pe: number
          pb: number
          nav: number
          dividend: [dividend, yield percentage, link, ex-div date]
        lastUpdatedAt: date 
```
