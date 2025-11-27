/ Real-time 10-level order book rebuild
/ Receives updates from gateway → maintains book table

\l book_schema.q

/ Update function for depth levels
.u.upd:{[t;x]
  if[t=`depth;
    `book upsert ([time:x`time; sym:x`sym; side:x`side; price:x`price; size:x`size; level:1+til 10] 
      where x`size>0)
  ]
 }

/ Live mid-price calculation
mid:{[s]
  b:first exec price from book where sym=s,side=`bid;
  a:first exec price from book where sym=s,side=`ask;
  (b+a)%2
 }

/ Spread
spread:{[s] (first exec price from book where sym=s,side=`ask) - (first exec price from book where sym=s,side=`bid)}

/ Start timer – log every 5 seconds
.z.ts:{-1"Time: ",string[.z.P]," | Mid: ",string[mid`BTCUSDT]," | Spread: ",string[spread`BTCUSDT]]}
system"t 5000"

\p 6000
-1"q-orderbook ready on port 6000 – waiting for Binance depth gateway...";
