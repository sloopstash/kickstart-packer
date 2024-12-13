# General variables
os_name = "ubuntu"
os_version = "24.04"
os_arch = "x86_64"
sources_enabled = ["source.virtualbox-iso.vm"]
vbox_boot_wait ="5s"
vbox_gfx_controller = "vboxvga"
vbox_gfx_vram_size = 33
vbox_guest_additions_interface = "sata"
vbox_guest_additions_mode = "upload"
vbox_guest_additions_path = "VBoxGuestAdditions_{{ .Version }}.iso"
vbox_guest_os_type = "Ubuntu_64"
vbox_hard_drive_interface = "sata"
vbox_iso_interface = "sata"
vboxmanage = [["modifyvm", "{{.Name}}", "--audio", "none"]]
virtualbox_version_file = ".vbox_version"
communicator ="ssh"
memory = 2048
output_directory = "new"
vm_name = "ubuntu-24.04-amd64"
shutdown_command = "sudo -S /sbin/halt -h -p"
boot_command = [
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
ssh_username = "tuto"
ssh_password = "vagrant"
cpus = 2
disk_size= 65536
headless = true
shutdown_timeout = "15m"
ssh_timeout = "15m"
ssh_port = 22
iso_url = "https://releases.ubuntu.com/jammy/ubuntu-22.04.5-live-server-amd64.iso"
iso_checksum = "file:https://releases.ubuntu.com/jammy/SHA256SUMS"