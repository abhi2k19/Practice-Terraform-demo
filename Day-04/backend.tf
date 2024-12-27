terraform {
  backend "s3" {
    bucket = "my-tf-mytest-s3bucket"
    region = "us-east-1"
    key = "prod/terraform.tfstate"
    dynamodb_table = "my-db-state-lock"
    
  }
}