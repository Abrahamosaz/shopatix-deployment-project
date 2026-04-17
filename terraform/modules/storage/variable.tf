variable "availability_zone" {
  description = "The AZ where the worker node and volume should reside"
  type        = string
}

variable "volume_size" {
  description = "Size of the volume in GB"
  type        = number
  default     = 20
}

variable "worker_instance_id" {
  description = "The ID of the worker instance to attach the volume to"
  type        = string
}

variable "resource_tags" {
  description = "Tags for the resources"
  type        = map(string)
}
