packer {
  required_version = ">= 1.7.0"
  required_plugins {
    vagrant = {
      version = ">= 1.0.2"
      source  = "github.com/hashicorp/vagrant"
    }
    virtualbox = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

# General variables
variable "os_name" {
  type        = string
  description = "OS Brand Name"
  default = "ubuntu"
}
variable "os_version" {
  type        = number
  description = "OS version number"
  default = "22.04"
}
variable "os_arch" {
  type = string
  default = "x86_64"
  }
variable "sources_enabled" {
  type = list(string)
  default = [
    "source.virtualbox-iso.vm"
  ]
  description = "Build Sources to use for building vagrant boxes"
}
variable "vbox_boot_wait" {
  type    = string
  default = "5s"
}
variable "vbox_gfx_controller" {
  type    = string
  default = "vboxvga"
}
variable "vbox_gfx_vram_size" {
  type    = number
  default = 33
}
variable "vbox_guest_additions_interface" {
  type    = string
  default = "sata"
}
variable "vbox_guest_additions_mode" {
  type    = string
  default = "upload"
}
variable "vbox_guest_additions_path" {
  type    = string
  default = "VBoxGuestAdditions_{{ .Version }}.iso"
}
variable "vbox_guest_os_type" {
  type        = string
  default     = "Ubuntu_64"
  description = "OS type for virtualization optimization"
}
variable "vbox_hard_drive_interface" {
  type    = string
  default = "sata"
}
variable "vbox_iso_interface" {
  type    = string
  default = "sata"
}
variable "vboxmanage" {
  type = list(list(string))
  default = [
    [
      "modifyvm",
      "{{.Name}}",
      "--audio",
      "none",
      "--nat-localhostreachable1",
      "on",
    ]
  ]
}
variable "virtualbox_version_file" {
  type    = string
  default = ".vbox_version"
}
variable "communicator" {
  type    = string
  default = "ssh"
}
variable "memory" {
  type    = number
  default = 2048
}
variable "output_directory" {
  type    = string
  default = "new"
}
variable "vm_name" {
  type    = string
  default = "ubuntu-24.04-amd64"
}
variable "shutdown_command" {
  type    = string
  default = "sudo -S /sbin/halt -h -p"
}
variable "boot_command" {
  type    = list(string)
  default = [
        "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
        "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
        "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
        "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
        "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
        "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
        "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
        "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
        "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
        "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
        "c<wait5>",
        "set gfxpayload=keep<enter><wait5>",
        "linux /casper/vmlinuz <wait5>",
        "autoinstall quiet fsck.mode=skip noprompt <wait5>",
        "net.ifnames=0 biosdevname=0 systemd.unified_cgroup_hierarchy=1 <wait5>",
        "ds=\"nocloud-net;s=https://github.com/DivyaPriya-Muthuvel/Packer-files/tree/main/ubuntu/\" <wait5>",
        "---<enter><wait5>",
        "initrd /casper/initrd<enter><wait5>",
        "boot<enter>"
      ]
}
variable "ssh_username" {
  type    = string
  default = "tuto"
}
variable "ssh_password" {
  type    = string
  default = "vagrant"
}
variable "cpus" {
  type    = number
  default = 2
}
variable "disk_size" {
  type    = number
  default = 65536
}
variable "headless" {
  type        = bool
  default     = true
  description = "Start GUI window to interact with VM"
}
variable "iso_url" {
  type        = string
  default     ="https://releases.ubuntu.com/jammy/ubuntu-22.04.5-live-server-amd64.iso"
  description = "ISO path"
}
variable "iso_checksum" {
  type        = string
  default     = "file:https://releases.ubuntu.com/jammy/SHA256SUMS"
  description = "ISO download checksum"
}
variable "shutdown_timeout" {
  type    = string
  default = "15m"
}
variable "ssh_timeout" {
  type    = string
  default = "15m"
}
variable "ssh_port" {
  type    = number
  default = 22
}

source "virtualbox-iso" "vm" {
  # Virtualbox specific options
  #firmware                  = "efi"
  gfx_controller            = var.vbox_gfx_controller
  gfx_vram_size             = var.vbox_gfx_vram_size
  guest_additions_path      = var.vbox_guest_additions_path
  guest_additions_mode      = var.vbox_guest_additions_mode
  guest_additions_interface = var.vbox_guest_additions_interface
  guest_os_type             = var.vbox_guest_os_type
  hard_drive_interface      = var.vbox_hard_drive_interface
  iso_interface             = var.vbox_iso_interface
  vboxmanage                = var.vboxmanage
  virtualbox_version_file   = var.virtualbox_version_file
  # Source block common options
  boot_command     = var.boot_command
  boot_wait        = var.vbox_boot_wait
  communicator     = var.communicator
  disk_size        = var.disk_size
  headless         = var.headless
  iso_url          = var.iso_url
  iso_checksum     = var.iso_checksum
  memory           = var.memory
  output_directory = var.output_directory
  shutdown_command = var.shutdown_command
  shutdown_timeout = var.shutdown_timeout
  ssh_password     = var.ssh_password
  ssh_port         = var.ssh_port
  ssh_timeout      = var.ssh_timeout
  ssh_username     = var.ssh_username
  vm_name          = var.vm_name
}

build {
  #sources = var.sources_enabled
  sources = [
    "source.virtualbox-iso.vm"
  ]
  # Convert machines to vagrant boxes
  post-processor "vagrant" {
    compression_level = 9
    output            = "${var.os_name}-${var.os_version}-${var.os_arch}.{{ .Provider }}.box"
    vagrantfile_template = null
  }
}
