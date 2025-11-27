# q-orderbook

Real-time 10-level order book rebuild in pure kdb+  
Live Binance depth10@100ms → incremental updates → wj1/aj → slippage calculation

## Features
- Full 10-level (top 10 bid + top 10 ask) order book from Binance
- Incremental updates (no full snapshot spam)
- Pure q rebuild with `wj1` and `aj` (zero Python dependency)
- Live mid-price, spread, imbalance calculation
- Ready for VPIN, toxicity, slippage backtesting

## Quick Start
```bash
# 1. Start Binance depth gateway
cd gateway && python binance_depth.py

# 2. Start order book process
q orderbook.q -p 6000

# 3. Query current book
q -p 6001
select price,size,side from book where sym=`BTCUSDT
