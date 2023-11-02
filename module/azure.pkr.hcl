packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}

variable "vn_name" {
  type = string
  description = "Virtual Network name."
}
variable "vn_sn_name" {
  type = string
  description = "Virtual Network subnet name."
}
variable "rg_name" {
  type = string
  description = "Resouce Group name."
}
variable "ssh_private_key_path" {
  type = string
  description = "SSH private key path."
}

source "azure-arm" "vm_base_v1_inst" {
  image_offer = "almalinux-x86_64"
  image_publisher = "almalinux"
  image_sku = "9-gen2" 
  location = "West US 2"
  managed_image_name = "sloopstash-almalinux-v1-ami"
  managed_image_resource_group_name = var.rg_name
  os_type = "Linux"
  communicator = "ssh"
  ssh_port = 22
  ssh_username = "azureuser"
  ssh_private_key_file = var.ssh_private_key_path
  ssh_timeout = "5m"
  vm_size = "Standard_B1ls"
  virtual_network_name = var.vn_name
  virtual_network_subnet_name = var.vn_sn_name
  virtual_network_resource_group_name = var.rg_name
  use_azure_cli_auth = true
  private_virtual_network_with_public_ip = true
  azure_tags = {
    Name = "base-v1-ami"
    Product = "crm"
  }
}

build {
  name = "vm_base_v1_img"
  sources = ["source.azure-arm.vm_base_v1_inst"]
  provisioner "shell" {
    only = ["azure-arm.vm_base_v1_inst"]
    inline_shebang = "/bin/bash -e"
    inline = [
      "sudo yum update -y",
      "sudo yum install -y wget vim initscripts gcc make tar unzip net-tools bind-utils nc nmap git",
      "sudo yum install -y python-pip",
      "sudo python -m pip install supervisor",
      "sudo mkdir /etc/supervisord.d",
      "sudo ln -s /usr/local/bin/supervisorctl /usr/bin/supervisorctl",
      "sudo ln -s /usr/local/bin/supervisord /usr/bin/supervisord",
      "history -c"
    ]
  }
}
