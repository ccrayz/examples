locals {
  ingress_rules = [
    {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.allowed_cidr_blocks
    },
    {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = var.allowed_cidr_blocks
    },
    {
      description = "vpn RPC"
      from_port   = 1194
      to_port     = 1194
      protocol    = "UDP"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Prometheus"
      from_port   = 9090
      to_port     = 9090
      protocol    = "TCP"
      cidr_blocks = var.allowed_cidr_blocks
    },
    {
      description = "Grafana"
      from_port   = 3000
      to_port     = 3000
      protocol    = "TCP"
      cidr_blocks = var.allowed_cidr_blocks
    }
  ]
}
resource "aws_security_group" "vpn" {
  name        = "vpn-sg"
  description = "security group for vpn"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "vpn-sg"
  }
}

