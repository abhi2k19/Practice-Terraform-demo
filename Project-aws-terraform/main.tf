provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
      name = "my_vpc"
    }
}
resource "aws_subnet" "public_subnet_az1" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
      name = "public_subnet_az1"
      type = "public"   
    }  
}
resource "aws_subnet" "public_subnet_az2" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
    tags = {
      name = "public_subnet_az2"
      type = "public"
    }
  
}
resource "aws_subnet" "private_subnet_az1" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false
  tags = {
    name = "private_subnet_az1"
    type = "private"
  }
}
resource "aws_subnet" "private_subnet_az2" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false
  tags = {
    name = "private_subnet_az2"
    type = "private"
  }
}
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    name = "my_igw"
  }
}
resource "aws_security_group" "ec2_sg" {
    vpc_id = aws_vpc.my_vpc.id
    ingress  {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress  {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "ec2_sg"
    }
  
}
resource "aws_eip" "nat_eip1" {
    domain = "vpc"
  
}
resource "aws_nat_gateway" "nat_gw1" {
    allocation_id = aws_eip.nat_eip1.id
    subnet_id  = aws_subnet.public_subnet_az1.id
    tags = {
      Name = "nat_gw1"
    }
}
resource "aws_eip" "nat_eip2" {
  domain = "vpc"
}
resource "aws_nat_gateway" "nat_gw2" {
    allocation_id = aws_eip.nat_eip2.id
    subnet_id = aws_subnet.public_subnet_az2.id
    tags = {
      Name = "nat_gw2"
    }
}
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.my_vpc.id
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_igw.id
    }
    tags = {
        Name = "public_rt"
    }
}
resource "aws_route_table_association" "public_rta1" {
    subnet_id = aws_subnet.public_subnet_az1.id
    route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "public_rta2" {
    subnet_id = aws_subnet.public_subnet_az2.id
    route_table_id = aws_route_table.public_rt.id  
}
resource "aws_route_table" "private_rt1" {
    vpc_id = aws_vpc.my_vpc.id
    route  {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_gw1.id

    }
    tags = {
      Name = "private_rt1"
    } 
}
resource "aws_route_table_association" "private_rta1" {
    subnet_id = aws_subnet.private_subnet_az1.id
    route_table_id = aws_route_table.private_rt1.id
  
}
resource "aws_route_table" "private_rt2" {
  vpc_id = aws_vpc.my_vpc.id
  route  {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw2.id
  }
  tags = {
    Name = "private_rt2"
  }
}
resource "aws_route_table_association" "private_rta2" {
  subnet_id = aws_subnet.private_subnet_az2.id
  route_table_id = aws_route_table.private_rt2.id
}
resource "aws_instance" "vpc_demo_ec2" {
    ami = "ami-0e2c8caa4b6378d8c"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.ec2_sg.id]
    subnet_id = aws_subnet.public_subnet_az1.id
    associate_public_ip_address = true
    key_name = "aws_login"
    tags = {
      Name = "vpc_demo_ec2"
    }
    user_data = <<-EOF
              #!/bin/bash
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "Welcome to Terraform Deployed App!" > /var/www/html/index.html
              EOF
}
  
