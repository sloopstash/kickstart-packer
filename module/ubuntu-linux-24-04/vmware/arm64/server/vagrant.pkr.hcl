packer {
  required_plugins {
    vmware = {
      version = "2.1.0"
      source = "github.com/vmware/vmware"
    }
    vagrant = {
      version = "1.1.6"
      source = "github.com/hashicorp/vagrant"
    }
  }
}

source "vagrant" "ubuntu_linux_24_04_vm" {
  // box_name = "sloopstash-ubuntu-linux-24-04-v1.1.1-box"
  source_path = "bento/ubuntu-24.04"
  provider = "vmware_fusion"
  skip_add = true
  communicator = "ssh"
  insert_key = true
  output_dir = "image/box"
}

build {
  name = "ubuntu_linux_24_04_box"
  sources = ["source.vagrant.ubuntu_linux_24_04_vm"]
  provisioner "shell" {
    only = ["vagrant.ubuntu_linux_24_04_vm"]
    inline_shebang = "/bin/bash -e"
    inline = [
      "sudo apt update",
      "sudo apt upgrade -y",
      "sudo systemctl enable apparmor",
      "sudo ufw allow ssh",
      "echo 'yes' | sudo ufw enable",
      "sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config",
      "sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config"
    ]
  }
}
