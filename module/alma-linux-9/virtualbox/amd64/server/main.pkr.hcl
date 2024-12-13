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
  default = "almalinux"
}
variable "os_version" {
  type        = number
  description = "OS version number"
  default = 9.4
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
  default     = "RedHat_64"
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
  default = "almalinux-9.4-amd64"
}
variable "shutdown_command" {
  type    = string
  default = "sudo -S /sbin/halt -h -p"
}
variable "boot_command" {
  type    = list(string)
  default = ["<wait><wait><up><wait><tab> inst.text inst.ks=https://gist.githubusercontent.com/DivyaPriya-Muthuvel/a69f60e8c114853d48ad5b6f92e10944/raw/198bcae12a2290aa93b4764aeae5977169decc20/9ks.cfg<enter><wait>"]
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
  default     = "https://repo.almalinux.org/almalinux/9/isos/x86_64/AlmaLinux-9.4-x86_64-dvd.iso"
  description = "ISO path"
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
variable "iso_checksum" {
  type        = string
  default     = "file:https://repo.almalinux.org/almalinux/9/isos/x86_64/CHECKSUM"
  description = "ISO download checksum"
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
  cpus             = var.cpus
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
