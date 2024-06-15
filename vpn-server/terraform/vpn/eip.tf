resource "aws_network_interface" "vpn" {
  subnet_id       = module.vpc.public_subnets[0]
  security_groups = [aws_security_group.vpn.id]
  private_ips     = ["10.0.0.10"]

  tags = {
    Name = "vpn-eni"
  }
}

resource "aws_eip" "one" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.vpn.id
  associate_with_private_ip = "10.0.0.10"

  tags = {
    Name = "vpn-eip"
  }
}
