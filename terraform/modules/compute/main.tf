
resource "aws_security_group" "vpc_manager_node_sg" {
  name        = "${var.resource_tags["Project"]}-manager-node-sg"
  description = "Manager node ports expose within vpc network"
  vpc_id      = var.vpc_id

  ingress {
    description      = "SSH from the internet"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  dynamic "ingress" {
    for_each = var.manager_node_ports
    iterator = port_rule
    content {
      description = port_rule.value.description
      from_port   = port_rule.value.port
      to_port     = port_rule.value.port
      protocol    = port_rule.value.protocol
      cidr_blocks = [var.vpc_cidr_block]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.resource_tags["Project"]}-worker-node-sg"
    }
  )
}



resource "aws_security_group" "vpc_worker_node_sg" {
  name        = "${var.resource_tags["Project"]}-worker-node-sg"
  description = "Worker node ports expose within vpc network"
  vpc_id      = var.vpc_id

  ingress {
    description      = "SSH from the internet"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  dynamic "ingress" {
    for_each = var.worker_node_ports
    iterator = port_rule
    content {
      description = port_rule.value.description
      from_port   = port_rule.value.port
      to_port     = port_rule.value.port
      protocol    = port_rule.value.protocol
      cidr_blocks = [var.vpc_cidr_block]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.resource_tags["Project"]}-worker-node-sg"
    }
  )
}


resource "aws_key_pair" "node_key" {
  key_name   = "${var.resource_tags["Project"]}-key"
  public_key = file("${path.root}/id_rsa.pub")
}


resource "aws_instance" "manager_node" {
  count                       = var.manager_node_count
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.node_key.key_name
  subnet_id                   = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids      = [aws_security_group.vpc_manager_node_sg.id]
  associate_public_ip_address = true

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.resource_tags["Project"]}-master${count.index}"
    }
  )
}


resource "aws_instance" "worker_node" {
  count                       = var.worker_node_count
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.node_key.key_name
  subnet_id                   = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids      = [aws_security_group.vpc_worker_node_sg.id]
  associate_public_ip_address = true


  tags = merge(
    var.resource_tags,
    {
      Name = "${var.resource_tags["Project"]}-worker${count.index}"
    }
  )
}
