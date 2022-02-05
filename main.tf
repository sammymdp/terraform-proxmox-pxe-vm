terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.9.5"
    }
    random = {
      source = "hashicorp/random"
      version = "3.1.0"
    }
    local = {
      source = "hashicorp/local"
      version = "2.1.0"
    }
  }
}

provider "proxmox" {
  pm_api_url = "${var.proxmox_url}/api2/json"
  pm_tls_insecure = var.proxmox_tls_insecure
}

resource "random_id" "mac_address" {
  byte_length = 8
}

locals {
  mac_address = upper(random_id.mac_address.hex)
  formatted_mac_addr = join(":", [
    substr(local.mac_address, 0, 2),
    substr(local.mac_address, 2, 2),
    substr(local.mac_address, 4, 2),
    substr(local.mac_address, 6, 2),
    substr(local.mac_address, 8, 2),
    substr(local.mac_address, 10, 2),
    substr(local.mac_address, 12, 2),
    substr(local.mac_address, 14, 2),
  ])
  pxe_config = templatefile("MAC-XXXX.ixpe.tpl", {
    custom_lines = var.custom_ipxe_lines,
    media_root = var.ipxe_media_root,
    kernel_name = var.ipxe_kernel_name,
    initrd_name = var.ipxe_initrd_name,
    cmdline_args = var.ipxe_cmdline_args
  })
}

resource "local_file" "ipxe_template" {
    content     = local.pxe_config
    filename = "${path.module}/MAC-${local.mac_address}.ipxe"
}

resource "null_resource" "ipxe_config" {
  triggers = {
    force_recreate_on_change_of = join(":", [local.pxe_config, local.formatted_mac_addr])
  }
  provisioner "file" {
    source      = local_file.ipxe_template.filename
    destination = "${var.ipxe_menu_path}/MAC-${local.mac_address}.ipxe"
    connection {
      type     = "ssh"
      user     = var.ipxe_server_username
      password = var.ipxe_server_password
      host     = var.ipxe_server_host
    }
  }
}

resource "proxmox_vm_qemu" "vm" {
  name        = var.name
  target_node = var.proxmox_target_node

  onboot = var.start_on_boot
  agent = var.enable_qemu_agent ? 1:0

  memory = var.memory
  balloon = var.min_memory
  cores = var.cpu_cores
  scsihw = var.scsi_hardware

  force_recreate_on_change_of = join(":", [local.pxe_config, local.formatted_mac_addr])

  pxe = true
  boot = "scsi0;net0"

  network {
    model = var.network_model
    macaddr = local.formatted_mac_addr
    bridge = var.network_bridge
  }

  dynamic "disk" {
    for_each = var.disks
    content {
      type = disk.value["type"]
      storage = disk.value["storage"]
      size = disk.value["size"]
    }
  }

  depends_on = [null_resource.ipxe_config]
}
