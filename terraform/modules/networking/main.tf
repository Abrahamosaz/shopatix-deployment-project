// vpc
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  enable_dns_support   = true
  enable_dns_hostnames = true


  tags = merge(
    var.resource_tags,
    {
      Name = "${var.resource_tags["Project"]}-main-vpc"
    }
  )
}


// private and public subnets
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidr_blocks)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.resource_tags["Project"]}-public-subnet-${count.index}"
    }
  )
}

resource "aws_subnet" "private_subnet" {
  count             = var.resource_tags["Environment"] == "prod" ? length(var.private_subnet_cidr_blocks) : 0
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.resource_tags["Project"]}-private-subnet-${count.index}"
    }
  )
}

// route table and routes
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.resource_tags["Project"]}-public-rt"
    }
  )
}


resource "aws_route_table" "private_rt" {
  count  = var.resource_tags["Environment"] == "prod" ? 1 : 0
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[0].id
  }


  tags = merge(
    var.resource_tags,
    {
      Name = "${var.resource_tags["Project"]}-private-rt"
    }
  )
}

//igw and natgw
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.resource_tags["Project"]}-main-igw"
    }
  )
}

resource "aws_eip" "nat_eip" {
  count  = var.resource_tags["Environment"] == "prod" ? 1 : 0
  domain = "vpc"

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.resource_tags["Project"]}-nat-eip"
    }
  )
}

resource "aws_nat_gateway" "nat_gw" {
  count         = var.resource_tags["Environment"] == "prod" ? 1 : 0
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.resource_tags["Project"]}-nat-gw"
    }
  )

  depends_on = [aws_internet_gateway.igw, aws_eip.nat_eip]

  timeouts {
    # NAT gateways can take a long time to fully delete in AWS.
    delete = "30m"
  }
}


# subnet associations
resource "aws_route_table_association" "public_subnet_assoc" {
  count          = length(var.public_subnet_cidr_blocks)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_subnet_assoc" {
  count          = var.resource_tags["Environment"] == "prod" ? length(var.private_subnet_cidr_blocks) : 0
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt[0].id
}
