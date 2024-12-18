terraform {
  backend "s3" {
    bucket = "abhi2k18bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"


  }
}