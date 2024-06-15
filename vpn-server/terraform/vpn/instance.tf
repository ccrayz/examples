resource "aws_key_pair" "vpn" {
  key_name   = "vpn-keypair"
  public_key = file("../../ssh/vpn-ec2-keypair.pub")
}

resource "aws_launch_template" "vpn" {
  name = "vpn-launch-template"

  disable_api_stop        = false
  disable_api_termination = false

  ebs_optimized                        = true
  image_id                             = var.ami_id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = var.instance_type

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = 20
      volume_type           = "gp3"
      iops                  = 3000
      throughput            = 125
      delete_on_termination = true
    }
  }

  update_default_version = true
  user_data              = filebase64("scripts/install.sh")
  key_name               = aws_key_pair.vpn.key_name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    network_interface_id = aws_network_interface.vpn.id
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "vpn-instance"
    }
  }
  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_instance" "vpn" {
  count = 1

  associate_public_ip_address = true

  launch_template {
    id      = aws_launch_template.vpn.id
    version = "$Latest"
  }

  lifecycle {
    ignore_changes = [
      instance_type,
    ]
  }
}
