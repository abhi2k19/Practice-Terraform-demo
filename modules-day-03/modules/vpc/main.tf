
resource "aws_vpc" "terraform_vpc" {
    cidr_block = var.cidr_block
    enable_dns_hostnames = true
    enable_dns_support = true
    
    tags = {
        Name = var.vpc_name
        Environment = var.environment
    }
  
}
resource "aws_subnet" "public" {
  count      = var.public_subnet_count  # e.g., 2 subnets
  vpc_id     = aws_vpc.terraform_vpc.id
  cidr_block = cidrsubnet(var.cidr_block, 8, count.index)

  tags = {
    Name = "${var.environment}-public-subnet-${count.index}"
  }
}
