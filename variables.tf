variable "name" {
  type        = string
  description = "Name for VM in Proxmox."
}

variable "proxmox_url" {
  type        = string
  sensitive   = true
  description = "The URL for Proxmox. The module will automatically append `/api2/json` for the API"
}

variable "proxmox_tls_insecure" {
  type        = bool
  default     = true
  description = "Whether the Proxmox TLS certificate is unverifiable."
}

variable "proxmox_target_node" {
  type        = string
  default     = "pve"
  description = "The target proxmox node name to deploy to."
}

variable "start_on_boot" {
  type        = bool
  default     = true
  description = "Set to allow the guest to be started when Proxmox boots."
}

variable "enable_qemu_agent" {
  type        = bool
  default     = true
  description = "Set to enable the QEMU agent in the guest."
}

variable "memory" {
  type        = number
  default     = 512
  description = "The amount of memory to give the VM, in MB."
}

variable "min_memory" {
  type        = number
  default     = 0
  description = "Set to enable minimum memory in MB for ballooning. This option will make `memory` the maximum."
}

variable "cpu_cores" {
  type        = number
  default     = 4
  description = "The number of CPU cores to give the VM."
}

variable "scsi_hardware" {
  type        = string
  default     = "virtio-scsi-pci"
  description = "The SCSI controller to emulate. Options: `lsi`, `lsi53c810`, `megasas`, `pvscsi`, `virtio-scsi-pci`, `virtio-scsi-single`."
}

variable "disks" {
  type = list(object({ type = string, storage = string, size = string }))
  default = [{
    type    = "virtio",
    storage = "local-lvm"
    size    = "16GB"
  }]
  description = "The disks to add to the VM."
}

variable "network_model" {
  type        = string
  default     = "virtio"
  description = "Set the network interface model. Options: `e1000`, `e1000-82540em`, `e1000-82544gc`, `e1000-82545em`, `i82551`, `i82557b`, `i82559er`, `ne2k_isa`, `ne2k_pci`, `pcnet`, `rtl8139`, `virtio`, `vmxnet3`."
}

variable "network_bridge" {
  type        = string
  default     = "vmbr0"
  description = "Set the network interface bridge. Typically `vmbr0`."
}

variable "custom_ipxe_lines" {
  type        = list(string)
  default     = []
  description = "Any custom lines to add to the iPXE prior to boot. Might be useful for command line variables."
}

variable "ipxe_media_root" {
  type        = string
  description = "Set the iPXE root. Can be a URL or a path on PXE TFTP server"
}

variable "ipxe_kernel_name" {
  type        = string
  description = "Set the iPXE kernel image name under `ipxe_media_root`."
}

variable "ipxe_initrd_name" {
  type        = string
  description = "Set the iPXE initrd image name under `ipxe_media_root`."
}

variable "ipxe_cmdline_args" {
  type        = string
  description = "Arguments passed to kernel in iPXE."
}

variable "ipxe_server_host" {
  type        = string
  description = "Host of the iPXE server to copy config to."
}

variable "ipxe_menu_path" {
  type        = string
  default     = "/mnt/storage/netboot.xyz/config/menus"
  description = "Path on iPXE host to iPXE configs."
}

variable "ipxe_server_username" {
  type        = string
  description = "Username on the iPXE server to copy config with."
}

variable "ipxe_server_password" {
  type        = string
  description = "Password on the iPXE server to copy config with."
}
