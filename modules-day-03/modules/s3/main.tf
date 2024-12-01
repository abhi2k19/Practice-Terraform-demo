resource "aws_s3_bucket" "abhi2k18newtf" {
    bucket = var.bucket_name
    tags = {
        name = var.bucket_name
        Environment = var.environment

    }
  
}