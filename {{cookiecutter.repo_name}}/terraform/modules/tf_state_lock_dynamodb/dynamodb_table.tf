resource "aws_dynamodb_table" "tf_state_lock" {
  name           = "tf-state-lock"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = var.name_tag
    Environment = var.environment_tag
  }
}
