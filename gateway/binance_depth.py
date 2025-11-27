# Binance 10-level order book WebSocket gateway
# Stream: depth10@100ms → sends only changed levels (incremental)
# Sends updates to q process on port 6000 via IPC

import websocket
import json
import os

Q_HOST = "localhost"
Q_PORT = 6000

def on_message(ws, message):
    data = json.loads(message)
    
    if 'e' in data and data['e'] == 'depthUpdate':
        # Send each bid/ask level as separate update
        for side, levels in [("bid", data['b']), ("ask", data['a'])]:
            for price, size in levels:
                if float(size) == 0:
                    continue  # ignore zero size
                update = (data['E'] * 1000000, `BTCUSDT, side, float(price), float(size))
                ws_q.send(json.dumps([".u.upd", `depth, update]))

    elif data.get("result") is None and "stream" in data:
        print(f"Connected to {data['stream']}")

# Connect to q process
ws_q = websocket.create_connection(f"ws://{Q_HOST}:{Q_PORT}")

# Binance 10-level depth stream
ws = websocket.WebSocketApp(
    "wss://stream.binance.com:9443/ws/btcusdt@depth10@100ms",
    on_message=on_message
)

print("Binance 10-level depth gateway started → sending to q on port 6000")
ws.run_forever()
