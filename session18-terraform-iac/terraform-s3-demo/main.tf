<<<<<<< HEAD
resource "aws_s3_bucket" "ananya0107" {
=======
resource "aws_s3_bucket" "devops553" {
>>>>>>> a6e7e9464a333058fc42f0b0102eb9bf689baa53
  bucket        = var.bucket_name
  force_destroy = true
  tags = {
    Name        = var.bucket_name
    Environment = "dev"
    ManagedBy   = "Terraform"
    Project     = "Session18"
  }
}
