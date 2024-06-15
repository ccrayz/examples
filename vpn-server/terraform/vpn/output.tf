output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "vpn_eip" {
  value = aws_eip.one.public_ip
}

output "vpn_eni" {
  value = aws_network_interface.vpn.private_ip
}

output "ec2_key_pair" {
  value = aws_key_pair.vpn.key_name
}

output "ec2_public_ip" {
  value = aws_eip.one.public_ip
}

output "ec2_private_ip" {
  value = aws_network_interface.vpn.private_ip
}

output "vpn_sg_id" {
  value = aws_security_group.vpn.id
}

output "vpn_sg_name" {
  value = aws_security_group.vpn.name
}

output "ebs_volume_id" {
  value = aws_ebs_volume.vpn.id
}
