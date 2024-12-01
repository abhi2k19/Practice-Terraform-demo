variable "cidr_block" {
    description = "cidr block for vpc"
    type = string

  
}
variable "vpc_name" {
    description = "name of vpc"
    type = string
    default = "default-vpc"
  
}
variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}
variable "public_subnet_count" {
  description = "Number of public subnets to create"
  type        = number
  default     = 2
}