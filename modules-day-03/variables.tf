variable "region" {
    type = string
    description = "AWS region"
  
}

variable "cidr_block" {
    description = "CIDR block for the VPC"
    type = string
    default = "10.0.0.0/16"
}
variable "vpc_name" {
    description = "Name of the VPC"
    type = string
    default = "myvpc"
}

variable "environment" {
    description = "Environment name"
    type = string
    default = "dev"
}
variable "bucket_name" {
    description = "S3 bucket name"
    type = string
    
}
variable "ami_id" {
    description = "AMI ID"
    type = string
  
}
variable "instance_type" {
    description = "EC2 instance type"
    type = string
}
  



