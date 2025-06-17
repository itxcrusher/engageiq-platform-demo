##############################
# 3. DynamoDB (chat history) #
##############################
resource "aws_dynamodb_table" "chat_history" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "PK"
  range_key    = "SK"

  attribute {
    name = "PK"
    type = "S"
  }

  attribute {
    name = "SK"
    type = "S"
  }

  tags = {
    Name        = "engageiq-chat-${var.environment}"
    Environment = var.environment
  }
}