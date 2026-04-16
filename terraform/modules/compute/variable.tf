variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the vpc"
  type        = string
}

variable "resource_tags" {
  description = "Tags for this project resources"
  type        = map(string)
}

variable "manager_node_ports" {
  description = "Manager node ports exposed within the VPC"
  type = list(object({
    port        = number
    protocol    = string
    description = string
  }))
}


variable "worker_node_ports" {
  description = "Worker node ports exposed within the VPC"
  type = list(object({
    port        = number
    protocol    = string
    description = string
  }))
}

variable "manager_node_count" {
  description = "Number of manager node"
  type        = number
  default     = 1
}


variable "worker_node_count" {
  description = "Number of worker node"
  type        = number
  default     = 1
}


variable "instance_type" {
  description = "Instance type for node"
  type        = string
  default     = "t3.small"
}


variable "subnet_ids" {
  description = "Subnets ID (private or public)"
  type        = list(string)
}
