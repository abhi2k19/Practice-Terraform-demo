variable "cidr_block" {
    description = "cidr block for vpc"
    type = string
    default = "10.0.0.0/16"
    }

variable "ami_id" {
    description = "ami id for ec2"
    type = string
    default = "ami-0866a3c8686eaeeba"
    }
  
