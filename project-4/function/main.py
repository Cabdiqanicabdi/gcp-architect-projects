import base64
import json
import functions_framework

@functions_framework.cloud_event
def process_order(cloud_event):
    pubsub_message = cloud_event.data["message"]

    if "data" in pubsub_message:
        message_data = base64.b64decode(pubsub_message["data"]).decode("utf-8")
    else:
        message_data = "{}"

    try:
        order = json.loads(message_data)
    except json.JSONDecodeError:
        print(f"ERROR: Could not parse message: {message_data}")
        raise

    print(f"Processing order: {order}")

    order_id = order.get("order_id", "unknown")
    customer = order.get("customer", "unknown")
    amount = order.get("amount", 0)
    item = order.get("item", "unknown")

    print(f"Order ID: {order_id}")
    print(f"Customer: {customer}")
    print(f"Item: {item}")
    print(f"Amount: {amount}")

    print(f"Order {order_id} processed successfully")
    return "OK"