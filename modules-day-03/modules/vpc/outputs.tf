output "vpc_id" {
    description = "The id of the created vpc"
    value = aws_vpc.terraform_vpc.id
  
}
output "public_subnet_ids" {
  value = [for subnet in aws_subnet.public : subnet.id]
}
