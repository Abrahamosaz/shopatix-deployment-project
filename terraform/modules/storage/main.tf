resource "aws_ebs_volume" "db_data" {
  availability_zone = var.availability_zone
  size              = var.volume_size
  type              = "gp3"
  encrypted         = true

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.resource_tags["Project"]}-db-storage"
    }
  )
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.db_data.id
  instance_id = var.worker_instance_id
}

output "volume_id" {
  value = aws_ebs_volume.db_data.id
}
