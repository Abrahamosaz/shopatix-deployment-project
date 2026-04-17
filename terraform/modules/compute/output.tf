output "manager_node_public_ips" {
  value = aws_instance.manager_node[*].public_ip
}

output "worker_node_public_ips" {
  value = aws_instance.worker_node[*].public_ip
}

output "manager_node_private_ips" {
  value = aws_instance.manager_node[*].private_ip
}

output "worker_node_private_ips" {
  value = aws_instance.worker_node[*].private_ip
}

output "worker_instance_ids" {
  value = aws_instance.worker_node[*].id
}

output "worker_azs" {
  value = aws_instance.worker_node[*].availability_zone
}
