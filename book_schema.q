/ Order book schema – 10-level depth (top 10 bid + top 10 ask)
/ Used for real-time rebuild from Binance depth10@100ms stream

book:(
  ([] 
    time:`timespan$();   / nanosecond timestamp
    sym:`symbol$();      / symbol e.g. `BTCUSDT
    side:`$();           / `bid or `ask
    price:`float$();     / price level
    size:`float$();      / quantity at this level
    level:`int$()        / 1-10 (1 = best price, 10 = deepest)
  )
 )

/ Apply attributes for maximum query performance
`sym`side`level xasc `book
`p#`sym`side`level book

/ Global reference
`book set book

-1"book schema loaded – ready for 10-level depth updates";
