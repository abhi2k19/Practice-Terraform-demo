provider "aws" {
    region = "us-east-1"
    profile = "default"
}
resource "aws_instance" "abhi_ec2" {
    instance_type = "t2.micro"
    ami = "ami-0866a3c8686eaeeba"
    tags = {
        name = "abhi_ec2"
    }
  
}
resource "aws_s3_bucket" "abhi_s3" {
    bucket = "abhi-s3-for-state"
       
}
resource "aws_dynamodb_table" "my-db-table" {
    name = "my-db-state-lock"
    hash_key = "LockID"
    billing_mode = "PAY_PER_REQUEST"
    attribute {
        name = "LockID"
        type = "S"
    }
 
  
}