output "topic_name" {
value = google_pubsub_topic.orders.name
}
output "function_name" {
value = google_cloudfunctions2_function.process_order.name
}
output "dead_letter_topic" {
value = google_pubsub_topic.orders_dead_letter.name
}
