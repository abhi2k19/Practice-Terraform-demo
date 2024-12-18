variable "region" {
  type        = string
  description = "region of the instance demo_wrkspc"

}

variable "ami_id" {
  #type = string
  description = "ami-id of the instance demo_wrkspc"
  type        = map(string)
  default = {
    "dev"   = "ami-05d38da78ce859165"
    "prod"  = "ami-0e2c8caa4b6378d8c"
    "stage" = "ami-0e2c8caa4b6378d8c"
  }

}
variable "instance_type" {
  description = "instance type of the instance demo_wrkspc"
  # type = string
  type = map(string)
  default = {
    "dev"   = "t2.micro"
    "prod"  = "t2.nano"
    "stage" = "t2.micro"
  }


}
variable "instance_name" {
  type        = string
  description = "instance name of the instance demo_wrkspc"

}