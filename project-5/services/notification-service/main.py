from flask import Flask, request, jsonify

app = Flask(__name__)

notifications = []

@app.route("/health")
def health():
    return jsonify({"status": "healthy", "service": "notification-service"})

@app.route("/notify", methods=["POST"])
def notify():
    data = request.get_json()
    message = data.get("message", "No message")
    notifications.append(message)
    print(f"NOTIFICATION SENT: {message}")
    return jsonify({"status": "notification sent", "message": message})

@app.route("/notifications", methods=["GET"])
def get_notifications():
    return jsonify(notifications)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)