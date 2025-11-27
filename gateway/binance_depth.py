import websocket
import json

Q_HOST = "localhost"
Q_PORT = 6000

def on_message(ws, message):
    data = json.loads(message)
    
    if 'e' in data and data['e'] == 'depthUpdate':
        ts = data['E'] * 1000000
        sym = "BTCUSDT"
        
        for side_str, levels in [("bid", data['b']), ("ask", data['a'])]:
            side = "bid" if side_str == "bid" else "ask"
            for i, (price_str, size_str) in enumerate(levels):
                price = float(price_str)
                size = float(size_str)
                if size == 0: 
                    continue
                level = i + 1
                update = [ts, sym, side, price, size, level]
                ws_q.send(json.dumps([".u.upd", "depth", update]))

# Connect to q
ws_q = websocket.create_connection(f"ws://{Q_HOST}:{Q_PORT}")

# Binance 10-level stream
ws = websocket.WebSocketApp(
    "wss://stream.binance.com:9443/ws/btcusdt@depth10@100ms",
    on_message=on_message
)

print("Binance 10-level gateway → q on port 6000")
ws.run_forever()
