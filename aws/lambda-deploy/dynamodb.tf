resource "aws_dynamodb_table" "notification_dynamodb_table" {
    name = "Notification"
    read_capacity = 5
    write_capacity = 5
    hash_key = "id"
    attribute {
      name = "id"
      type = "S"
    }
}
