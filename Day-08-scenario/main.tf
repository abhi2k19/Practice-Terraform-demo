provider "aws" {
    region = "us-east-1"
  
}
# import {
#   id = "i-084e4df46e609e758"
#   to = aws_instance.example
# }
# ---------------terraform plan "-generate-config-out=generate.tf"----------------
resource "aws_instance" "example" {
  ami                                  = "ami-0e2c8caa4b6378d8c"
  associate_public_ip_address          = true
  availability_zone                    = "us-east-1c"
  disable_api_stop                     = false
  disable_api_termination              = false
  ebs_optimized                        = false
  enable_primary_ipv6                  = null
  get_password_data                    = false
  hibernation                          = false
  host_id                              = null
  host_resource_group_arn              = null
  iam_instance_profile                 = null
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t2.micro"
  key_name                             = "aws_login"
  monitoring                           = false
  placement_group                      = null
  placement_partition_number           = 0
  private_ip                           = "172.31.40.149"
  secondary_private_ips                = []
  security_groups                      = ["launch-wizard-3"]
  source_dest_check                    = true
  subnet_id                            = "subnet-0d1158362093d6118"
  tags = {
    Name = "vault-instance"
  }
  tags_all = {
    Name = "vault-instance"
  }
  tenancy                     = "default"
  user_data                   = null
  user_data_base64            = null
  user_data_replace_on_change = null
  volume_tags                 = null
  vpc_security_group_ids      = ["sg-09ebdb50f7933c24c"]
  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }
  cpu_options {
    amd_sev_snp      = null
    core_count       = 1
    threads_per_core = 1
  }
  credit_specification {
    cpu_credits = "standard"
  }
  enclave_options {
    enabled = false
  }
  maintenance_options {
    auto_recovery = "default"
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "required"
    instance_metadata_tags      = "disabled"
  }
  private_dns_name_options {
    enable_resource_name_dns_a_record    = true
    enable_resource_name_dns_aaaa_record = false
    hostname_type                        = "ip-name"
  }
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    iops                  = 3000
    kms_key_id            = null
    tags                  = {}
    tags_all              = {}
    throughput            = 125
    volume_size           = 30
    volume_type           = "gp3"
  }
}
