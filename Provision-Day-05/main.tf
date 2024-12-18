provider "aws" {
    region = "us-east-1"
  
}
resource "aws_key_pair" "my_keys" {
    key_name = "aws_login.pem"
    public_key = file("terraform_key.pub")    
    }
resource "aws_vpc" "my_vpc" {
    cidr_block = var.cidr_block
    tags = {
        Name = "my_vpc"
    } 
}
resource "aws_subnet" "my_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true  
}
resource "aws_internet_gateway" "my_ig" {
    vpc_id = aws_vpc.my_vpc.id
  
}
resource "aws_route_table" "my_rtb" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_ig.id 
        } 
}
resource "aws_route_table_association" "my_rtb_assoc" {
    subnet_id = aws_subnet.my_subnet.id
    route_table_id = aws_route_table.my_rtb.id
  
}
resource "aws_security_group" "my_sg"{
    name = "Web"
    vpc_id = aws_vpc.my_vpc.id
    ingress {
        description = "allow SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "allow HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        name = "Web-sg"
    }
}
resource "aws_instance" "my_server" {
    ami = var.ami_id
    instance_type = "t2.micro"
    key_name = aws_key_pair.my_keys.key_name
    vpc_security_group_ids = [aws_security_group.my_sg.id]
    subnet_id = aws_subnet.my_subnet.id
    connection {
        type = "ssh"
        user = "ubuntu"
        private_key = file("terraform_key")
        host = self.public_ip
      
    }
     # File provisioner to copy a file from local to the remote EC2 instance
     provisioner "file" {
        source = "app.py"
        destination = "/home/ubuntu/app.py"  
     }
      provisioner "remote-exec" {
          inline = [
            "echo 'Hello from the remote instance'",
            "sudo apt update -y",  # Update package lists (for ubuntu)
            "sudo apt-get install -y python3-pip",  # Example package installation
            "cd /home/ubuntu",
            "sudo pip3 install flask",
            "sudo python3 app.py &",
            ]
           
     }
}

    
  

