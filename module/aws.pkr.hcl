packer {
  required_plugins {
    amazon = {
      version = "1.0.0"
      source = "github.com/hashicorp/amazon"
    }
  }
}

variable "region" {
  type = string
  description = "Region."
}
variable "vpc_net_id" {
  type = string
  description = "VPC network identifier."
}
variable "vpc_sn_id" {
  type = string
  description = "VPC subnet identifier."
}
variable "vpc_sg_id" {
  type = string
  description = "VPC security group identifier."
}
variable "ec2_source_ami_id" {
  type = string
  description = "EC2 source AMI identifier."
}
variable "ec2_key_pair_name" {
  type = string
  description = "EC2 key pair name."
}
variable "kms_key_id" {
  type = string
  description = "KMS key identifier."
}
variable "ssh_private_key_path" {
  type = string
  description = "SSH private key path."
}

source "amazon-ebs" "ec2_base_inst" {
  ami_name = "sloopstash-amazonlinux-v1-ami"
  region = var.region
  vpc_id = var.vpc_net_id
  subnet_id = var.vpc_sn_id
  security_group_id = var.vpc_sg_id
  source_ami = var.ec2_source_ami_id
  instance_type = "t3a.nano"
  associate_public_ip_address = true
  ami_virtualization_type = "hvm"
  force_deregister = true
  force_delete_snapshot = true
  encrypt_boot = true
  kms_key_id = var.kms_key_id
  skip_save_build_region = false
  skip_metadata_api_check = false
  skip_credential_validation = false
  aws_polling {
    max_attempts = 40
    delay_seconds = 15
  }
  disable_stop_instance = false
  ebs_optimized = false
  enable_t2_unlimited = false
  skip_profile_validation = false
  shutdown_behavior = "terminate"
  tenancy = "default"
  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "optional"
    http_put_response_hop_limit = 1
  }
  communicator = "ssh"
  ssh_interface = "public_dns"
  ssh_port = 22
  ssh_username = "ec2-user"
  ssh_keypair_name = var.ec2_key_pair_name
  ssh_private_key_file = var.ssh_private_key_path
  ssh_timeout = "1m"
  tags = {
    Name = "base-v1-ami"
    Region = var.region
  }
}

build {
  name = "ec2_base_img"
  sources = ["source.amazon-ebs.ec2_base_inst"]
  provisioner "shell" {
    only = ["amazon-ebs.ec2_base_inst"]
    inline_shebang = "/bin/bash -e"
    inline = [
      "sudo yum update -y",
      "sudo yum install -y wget vim initscripts gcc make tar unzip net-tools bind-utils nc nmap",
      "sudo yum install -y python-devel python-pip python-setuptools",
      "sudo yum install -y openssh-server openssh-clients passwd git",
      "sudo easy_install supervisor",
      "sudo mkdir /etc/supervisord.d",
      "history -c"
    ]
  }
}
