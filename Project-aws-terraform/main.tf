
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags = {
    Name = "my_vpc"
  }

}
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    name = "public_subnet_az1"
    type = "public"
  }
}
resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    name = "public_subnet_az2"
    type = "public"
  }

}
resource "aws_subnet" "private_subnet_az1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false
  tags = {
    name = "private_subnet_az1"
    type = "private"
  }
}
resource "aws_subnet" "private_subnet_az2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-1b"
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
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
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
  subnet_id     = aws_subnet.public_subnet_az1.id
  tags = {
    Name = "nat_gw1"
  }
}
resource "aws_eip" "nat_eip2" {
  domain = "vpc"
}
resource "aws_nat_gateway" "nat_gw2" {
  allocation_id = aws_eip.nat_eip2.id
  subnet_id     = aws_subnet.public_subnet_az2.id
  tags = {
    Name = "nat_gw2"
  }
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = {
    Name = "public_rt"
  }
}
resource "aws_route_table_association" "public_rta1" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "public_rta2" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table" "private_rt1" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw1.id

  }
  tags = {
    Name = "private_rt1"
  }
}
resource "aws_route_table_association" "private_rta1" {
  subnet_id      = aws_subnet.private_subnet_az1.id
  route_table_id = aws_route_table.private_rt1.id

}
resource "aws_route_table" "private_rt2" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw2.id
  }
  tags = {
    Name = "private_rt2"
  }
}
resource "aws_route_table_association" "private_rta2" {
  subnet_id      = aws_subnet.private_subnet_az2.id
  route_table_id = aws_route_table.private_rt2.id
}
resource "aws_instance" "vpc_demo_ec2" {
  # count = 2
  ami                         = "ami-0e2c8caa4b6378d8c"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  subnet_id                   = aws_subnet.public_subnet_az1.id
  associate_public_ip_address = true
  key_name                    = "aws_login"
  tags = {
    Name = "vpc_demo_ec2"
  }
  user_data = file("userdata.sh")
}

#    -------------------1. Dynamic Instance Discovery Using Tags---------------------
# Instead of hardcoding or filtering instance names, use AWS tags to dynamically discover instances that should be attached to your target group.
#  This approach is scalable, reduces complexity, and avoids errors when instance names or IDs change.

# Create instances with a specific tag for target group membership

# tags = {
#   Name = "vpc_demo_${count.index +1}"
#   Environment = "Dev"
#   TargetGroupMember = "true"
# }

# Use data source to dynamically fetch instances based on tags

# data "aws_instances" "tg_members" {
#   filter {
#     name   = "tag:TargetGroupMember"
#     values = ["true"]
#   }

#   filter {
#     name   = "instance-state-name"
#     values = ["running"]
#   }
# }

# Attach the dynamically discovered instances to the target group (---(for_each = toset) | (count = lenth))

# resource "aws_lb_target_group_attachment" "tg_attachment" {
#   for_each         = toset(data.aws_instances.tg_members.ids)
#   target_group_arn = aws_lb_target_group.my_target_group.arn
#   target_id        = each.value
#   port             = 80
# }
resource "aws_instance" "vpc_demo_ec3" {
  ami                         = "ami-0e2c8caa4b6378d8c"
  instance_type               = "t2.nano"
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  subnet_id                   = aws_subnet.public_subnet_az2.id
  associate_public_ip_address = true
  key_name                    = "aws_login"
  tags = {
    Name = "vpc_demo_ec3"
  }
  user_data = file("userdata2.sh")
}
resource "aws_s3_bucket" "example_s3" {
  bucket = "my-tf-mytest-s3bucket"
}
resource "aws_dynamodb_table" "my-db01" {
  name         = "my-db-state-lock"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
}
resource "aws_security_group" "lb_sg" {
  name   = "lb_sg"
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.public_subnet_az1.id, aws_subnet.public_subnet_az2.id]

  enable_deletion_protection = true

 # Enable access logging
  access_logs {
    bucket  = "my-tf-mytest-s3bucket"
    prefix  = "logs"
    enabled = true
  }
}
#----------------- 2.Autoscaling Group Integration----------------

#  If your instances are part of an autoscaling group (ASG), the ASG can handle attaching instances to the target group automatically.

# -----Create a load balancer target group
# resource "aws_lb_target_group" "my_target_group" {
#   name     = "my-tg"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.my_vpc.id
# }

#------- Create an autoscaling group
# resource "aws_autoscaling_group" "asg" {
#   launch_configuration = aws_launch_configuration.lc.id
#   min_size             = 2
#   max_size             = 10
#   desired_capacity     = 4

#   target_group_arns = [aws_lb_target_group.my_target_group.arn]
#   vpc_zone_identifier = [
#     aws_subnet.public_subnet_az1.id,
#     aws_subnet.public_subnet_az2.id,
#   ]
# }

resource "aws_lb_target_group" "my_target_group" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
  tags = {
    Name = "mytargetgroup"
  }
}

# ------Not A Best Practice-----
# (use (for_each = toset) | (count = lenth) )
resource "aws_lb_target_group_attachment" "my_tg_attachment1" {
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = aws_instance.vpc_demo_ec2.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "my_tg_attachment2" {
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = aws_instance.vpc_demo_ec3.id
  port             = 80
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.test.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }

}
output "load_balancer_arn" {
  value = aws_lb.test.dns_name

}