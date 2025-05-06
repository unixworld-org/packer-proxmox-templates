packer {
  required_plugins {
    name = {
      version = "~> 1.1.3"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

# Variable Definitions
variable "proxmox_api_url" {
    type = string
}

variable "proxmox_api_token_id" {
    type = string
}

variable "proxmox_api_token_secret" {
    type = string
    sensitive = true
}

variable "proxmox_node" {
    type = string
}

variable "root_password" {
    type = string
    sensitive = true
    description = "Unencrypted root password for the VM"
}

variable "timezone" {
    type = string
    description = "Timezone for the VM"
}

variable "ssh_public_key" {
    type = string
    description = "SSH public key to add to root account"
}

variable "vm_cores" {
    type = string
    description = "Number of CPU cores for the VM"
}

variable "vm_memory" {
    type = string
    description = "Amount of memory for the VM in MB"
}

variable "vm_disk_size" {
    type = string
    description = "Disk size for the VM"
}

variable "vm_storage_pool" {
    type = string
    description = "Storage pool for VM disk"
}

variable "vm_disk_format" {
    type = string
    description = "Disk format (raw, qcow2, etc.)"
}

variable "iso_storage_pool" {
    type = string
    description = "Storage pool for ISO files"
}

variable "ubuntu2404_iso" {
    type = string
    description = "Path to the Ubuntu 24.04 ISO file"
}

source "proxmox-iso" "ubuntu-server-noble-numbat" {
 
    proxmox_url = "${var.proxmox_api_url}"
    username = "${var.proxmox_api_token_id}"
    token = "${var.proxmox_api_token_secret}"

    node = "${var.proxmox_node}"
    vm_name = "ubuntu-server-noble-numbat"
    template_description = "Noble Numbat"

    # Replace deprecated ISO parameters with boot_iso block
    boot_iso {
        iso_file = "${var.ubuntu2404_iso}"
        iso_storage_pool = "${var.iso_storage_pool}"
        unmount = true
    }
    
    template_name = "packer-ubuntu2404"

    qemu_agent = true

    scsi_controller = "virtio-scsi-single"

    disks {
        disk_size = "${var.vm_disk_size}"
        format = "${var.vm_disk_format}"
        storage_pool = "${var.vm_storage_pool}"
        type = "scsi"
    }

    cores = "${var.vm_cores}"
    memory = "${var.vm_memory}" 
    cpu_type = "host"
    network_adapters {
        model = "virtio"
        bridge = "vmbr0"
        firewall = "false"
    } 

    cloud_init = true
    cloud_init_storage_pool = "${var.vm_storage_pool}"
    
    boot_command = [
        "<esc><wait>",
        "e<wait>",
        "<down><down><down><end>",
        "<bs><bs><bs><bs><wait>",
        "autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<wait>",
        "<f10><wait>"
    ]
    boot = "c"
    boot_wait = "5s"

    # Use templatefile function to process the user-data template with variables
    http_content = {
        "/meta-data" = file("http/meta-data")
        "/user-data" = templatefile("http/user-data.pkrtpl.hcl", {
            root_password = var.root_password
            ssh_public_key = var.ssh_public_key
            timezone = var.timezone
        })
    }

    ssh_username = "ubuntu"
    ssh_password = "${var.root_password}"
    ssh_timeout = "20m"
}

build {

    name = "ubuntu-server-noble-numbat"
    sources = ["proxmox-iso.ubuntu-server-noble-numbat"]

    provisioner "shell" {
        inline = [
            "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
            "sudo rm /etc/ssh/ssh_host_*",
            "sudo truncate -s 0 /etc/machine-id",
            "sudo apt -y autoremove --purge",
            "sudo apt -y clean",
            "sudo apt -y autoclean",
            "sudo cloud-init clean",
            "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
            "sudo rm -f /etc/netplan/00-installer-config.yaml",
            "sudo sync"
        ]
    }

    provisioner "file" {
        source = "ubuntu2404/files/99-pve.cfg"
        destination = "/tmp/99-pve.cfg"
    }

    provisioner "shell" {
        inline = [ "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg" ]
    }
}
