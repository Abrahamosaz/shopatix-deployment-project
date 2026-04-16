provider "aws" {
  profile = "shopAtix"
  region  = var.region
}


module "networking" {
  source = "../../modules/networking"

  vpc_cidr_block             = var.vpc_cidr_block
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  resource_tags              = var.resource_tags
  region                     = var.region
  availability_zones         = var.availability_zones
}



module "compute" {
  source = "../../modules/compute"

  vpc_cidr_block = var.vpc_cidr_block
  vpc_id         = module.networking.vpc_id
  resource_tags  = var.resource_tags

  manager_node_ports = [
    { port = 2377, protocol = "tcp", description = "Docker Swarm cluster management" },
    { port = 7946, protocol = "tcp", description = "Container network discovery (TCP)" },
    { port = 7946, protocol = "udp", description = "Container network discovery (UDP)" },
    { port = 4789, protocol = "udp", description = "VXLAN overlay network" }
  ]

  worker_node_ports = [
    { port = 7946, protocol = "tcp", description = "Public discovery TCP" },
    { port = 7946, protocol = "udp", description = "Public discovery UDP" },
    { port = 4789, protocol = "udp", description = "Public VXLAN" }
  ]

  manager_node_count = 1
  worker_node_count  = 1
  instance_type      = "t3.small"

  subnet_ids = module.networking.public_subnet_ids
}

