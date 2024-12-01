provider "aws" {
    region = var.region
  
}

module "vpc" {
    source = "./modules/vpc"
    cidr_block = var.cidr_block
    vpc_name = var.vpc_name
    environment = var.environment
  
}
 module "s3" {
    source = "./modules/s3"
    bucket_name = var.bucket_name
    environment = var.environment 
 }
 
module "ec2" {
  source       = "./modules/ec2"  # Path to your EC2 module
  ami_id       = var.ami_id       # Pass variable values here
  instance_type = var.instance_type
  subnet_id = module.vpc.public_subnet_ids[0]  # Accessing the first subnet ID

  environment  = var.environment
}
