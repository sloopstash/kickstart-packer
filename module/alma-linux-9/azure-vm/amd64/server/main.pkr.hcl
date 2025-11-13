packer {
  required_plugins {
    azure = {
      version = "2.5.0"
      source = "github.com/hashicorp/azure"
    }
  }
}

variable "region" {
  type = string
  description = "Region."
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

source "azure-arm" "alma_linux_9_vm" {
  managed_image_name = "sloopstash-alma-linux-9-v1.1.1-img"
  location = var.region
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
    Name = "sloopstash-alma-linux-9-v1.1.1-img"
    Region = var.region
    Organization = "sloopstash"
  }
}

build {
  name = "alma_linux_9_image"
  sources = ["source.azure-arm.alma_linux_9_vm"]
  provisioner "shell" {
    only = ["azure-arm.alma_linux_9_vm"]
    inline_shebang = "/bin/bash -e"
    inline = [
      "sudo dnf update -y",
      "sudo dnf install -y wget vim net-tools gcc make tar git unzip sysstat tree initscripts bind-utils nc nmap logrotate crontabs",
      "sudo dnf install -y python-devel python-pip python-setuptools",
      "sudo dnf clean all",
      "sudo rm -rf /var/cache/dnf",
      "sudo python3 -m pip install supervisor",
      "sudo mkdir /etc/supervisord.d",
      "history -c"
    ]
  }
}
