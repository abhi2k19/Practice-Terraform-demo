terraform {
  backend "s3" {
    bucket = "abhi-s3-for-state"
    region = "us-east-1"
    key = "prod/terraform.tfstate"
    dynamodb_table = "my-db-state-lock"
    
  }
}