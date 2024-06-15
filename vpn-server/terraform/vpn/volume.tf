resource "aws_ebs_volume" "vpn" {
  availability_zone = var.availability_zones[0]
  size              = 20
  type              = "gp3"
  iops              = 3000
  throughput        = 125

  encrypted = true

  tags = {
    Name = "vpn DB Volume"
  }
}

resource "aws_volume_attachment" "vpn_ebs_att" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.vpn.id
  instance_id = aws_instance.vpn[0].id
}
