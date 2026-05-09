import os
import requests
from flask import Flask, request, jsonify

app = Flask(__name__)

ORDER_SERVICE_URL = os.environ.get("ORDER_SERVICE_URL", "http://order-service:8080")

@app.route("/health")
def health():
    return jsonify({"status": "healthy", "service": "api-gateway"})

@app.route("/orders", methods=["GET"])
def get_orders():
    response = requests.get(f"{ORDER_SERVICE_URL}/orders")
    return jsonify(response.json())

@app.route("/orders", methods=["POST"])
def create_order():
    response = requests.post(f"{ORDER_SERVICE_URL}/orders", json=request.get_json())
    return jsonify(response.json()), response.status_code

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)