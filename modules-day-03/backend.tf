terraform {
  
  backend "s3" {
    bucket = "abhi2k18newtf"
    key = "Dev/terraform.tfstate"
    region = "us-east-1"
        
  }
}