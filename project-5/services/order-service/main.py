import os
import requests
from flask import Flask, request, jsonify

app = Flask(__name__)

NOTIFICATION_SERVICE_URL = os.environ.get("NOTIFICATION_SERVICE_URL", "http://notification-service:8080")

orders = []

@app.route("/health")
def health():
    return jsonify({"status": "healthy", "service": "order-service"})

@app.route("/orders", methods=["GET"])
def get_orders():
    return jsonify(orders)

@app.route("/orders", methods=["POST"])
def create_order():
    order = request.get_json()
    order["id"] = len(orders) + 1
    orders.append(order)
    try:
        requests.post(
            f"{NOTIFICATION_SERVICE_URL}/notify",
            json={"message": f"Order {order['id']} created for {order.get('customer', 'unknown')}"},
            timeout=5
        )
    except Exception as e:
        print(f"Notification failed: {e}")
    return jsonify(order), 201

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)