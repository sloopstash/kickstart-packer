packer {
  required_plugins {
    azure = {
      version = "2.0.2"
      source = "github.com/hashicorp/azure"
    }
  }
}

variable "rg_name" {
  type = string
  description = "Resource group name."
}
variable "vnet_name" {
  type = string
  description = "Virtual network name."
}
variable "vnet_sn_name" {
  type = string
  description = "Virtual network subnet name."
}
variable "ssh_private_key_path" {
  type = string
  description = "SSH private key path."
}

source "azure-arm" "base_v1_vm" {
  managed_image_name = "sloopstash-base-v1.1.1-image"
  location = "Central India"
  managed_image_resource_group_name = var.rg_name
  virtual_network_name = var.vnet_name
  virtual_network_subnet_name = var.vnet_sn_name
  virtual_network_resource_group_name = var.rg_name
  private_virtual_network_with_public_ip = true
  image_publisher = "almalinux"
  image_offer = "almalinux-x86_64"
  image_sku = "9-gen2"
  vm_size = "Standard_B1s"
  os_type = "Linux"
  use_azure_cli_auth = true
  communicator = "ssh"
  ssh_port = 22
  ssh_username = "azureuser"
  ssh_private_key_file = var.ssh_private_key_path
  ssh_timeout = "1m"
  azure_tags = {
    Name = "sloopstash-base-v1.1.1-image"
    Region = "centralindia"
    Organization = "sloopstash"
  }
}

build {
  name = "base_v1_image"
  sources = ["source.azure-arm.base_v1_vm"]
  provisioner "shell" {
    only = ["azure-arm.base_v1_vm"]
    inline_shebang = "/bin/bash -e"
    inline = [
      "sudo yum update -y",
      "sudo yum install -y wget vim nano net-tools gcc make tar git unzip sysstat tree initscripts bind-utils nc nmap",
      "sudo yum install -y python-devel python-pip python-setuptools",
      "sudo python -m pip install supervisor",
      "sudo mkdir /etc/supervisord.d",
      "sudo ln -s /usr/local/bin/supervisorctl /usr/bin/supervisorctl",
      "sudo ln -s /usr/local/bin/supervisord /usr/bin/supervisord",
      "history -c"
    ]
  }
}
