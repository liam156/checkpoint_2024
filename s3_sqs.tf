resource "aws_sqs_queue" "app_queue" {
  name                        = "app-queue"
  visibility_timeout_seconds   = 30
  message_retention_seconds    = 86400
  receive_wait_time_seconds    = 20

  tags = {
    Name = "app-queue"
  }
}

resource "aws_s3_bucket" "app_bucket" {
  bucket = "app-bucket-${random_string.s3_suffix.result}"  # Make the bucket name unique
  acl    = "private"

  tags = {
    Name = "app-bucket"
  }
}

# Random string for S3 bucket uniqueness
resource "random_string" "s3_suffix" {
  length  = 8
  special = false
  upper   = false
}