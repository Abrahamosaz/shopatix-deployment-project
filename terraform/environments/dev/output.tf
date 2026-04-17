output "manager_ips" {
  value = module.compute.manager_node_public_ips
}

output "worker_ips" {
  value = module.compute.worker_node_public_ips
}

output "manager_private_ips" {
  value = module.compute.manager_node_private_ips
}

output "worker_private_ips" {
  value = module.compute.worker_node_private_ips
}
