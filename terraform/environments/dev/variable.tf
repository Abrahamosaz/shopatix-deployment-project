variable "vpc_cidr_block" {
  description = "CIDR range for vpc"
  type        = string
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for private subnets."
  type        = list(string)
}

variable "resource_tags" {
  description = "Tags for this project resources"
  type        = map(string)
}

variable "region" {
  description = "Region for deploying resources"
  type        = string
}

variable "availability_zones" {
  description = "Multi AZ for high availability, it should match the number of subnets (both private and public)"
  type        = list(string)
}

variable "bucket_name" {
  description = "Bucket name for storing state file"
  type        = string
}

variable "bucket_key_path" {
  description = "Folder path to the bucket folder to store the state file"
  type        = string
}
