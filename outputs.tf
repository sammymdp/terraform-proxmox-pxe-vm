output "ssh_host" {
  value       = proxmox_vm_qemu.vm.ssh_host
  description = "The hostname of the target, as obtained via QEMU Guest Agent"
  sensitive   = true
}
