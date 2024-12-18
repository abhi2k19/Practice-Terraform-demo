provider "aws" {
  region = var.region
}
locals {
  instance_name = "${terraform.workspace}-instance"

}
module "ec2" {
  source        = "./modules/ec2"
  region        = var.region
  ami_id        = lookup(var.ami_id, terraform.workspace, "error")
  instance_name = local.instance_name
  instance_type = lookup(var.instance_type, terraform.workspace, "error")
  # instance_type = var.instance_type

}