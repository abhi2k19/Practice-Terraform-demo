resource "aws_instance" "example" {
  ami           = var.ami_id       # Use variable passed from root module
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  tags = {
    Name = "${var.environment}-instance"
  }
}
