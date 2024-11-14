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