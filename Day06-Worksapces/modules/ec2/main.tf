provider "aws" {
    region = var.region
  
}
resource "aws_instance" "EC2-Module" {
    ami = var.ami_id
    instance_type = var.instance_type
    tags = {
      instance_name = var.instance_name
    }
    
  
}