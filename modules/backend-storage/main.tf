variable "bucket_name" {
  # Replace 'aquib-2026' with your name or random numbers to guarantee global uniqueness
  default = "skillslab-tfstate-bucket-aquib-2026" 
}

resource "aws_s3_bucket" "backend_storage" {
  bucket        = var.bucket_name
  force_destroy = true
  tags          = { Environment = "dev" }
}

# Enforce encryption on backend records
resource "aws_s3_bucket_server_side_encryption_configuration" "state_encryption" {
  bucket = aws_s3_bucket.backend_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_dynamodb_table" "tfstate_lock" {
  name         = "tfstate-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = { Environment = "dev" }

}
# checking triggering of terraform fmt