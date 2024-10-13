resource "aws_s3_bucket" "remote_state" {
  bucket        = "remote-state-123"
  force_destroy = true

  tags = {
    Name        = "remote-state"
    Environment = var.env
  }
}

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "RemoteState"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }


  tags = {
    Name        = "remote-state"
    Environment = "production"
  }
}
