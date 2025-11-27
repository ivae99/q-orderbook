\l book_schema.q

/ Correct update – only one row per level
.u.upd:{[t;x]
  if[t=`depth;
    `book upsert enlist x
  ]
 }

/ Correct mid-price
mid:{[s]
  b:first exec price from book where sym=s, side=`bid;
  a:first exec price from book where sym=s, side=`ask;
  (b + a) / 2
 }

spread:{[s]
  a:first exec price from book where sym=s, side=`ask;
  b:first exec price from book where sym=s, side=`bid;
  a - b
 }

.z.ts:{-1"Mid: ",string[mid `BTCUSDT]," | Spread: ",string[spread `BTCUSDT]]}
system"t 1000"    / her saniye log
\p 6000
-1"q-orderbook ready on port 6000";
