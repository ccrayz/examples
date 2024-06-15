variable "aws_region" {
  type    = string
  default = "ap-northeast-2"
}

variable "availability_zones" {
  type    = list(string)
  default = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "vpc_name" {
  type    = string
  default = "vpn-vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "default_tags" {
  type = map(string)
  default = {
    Terraform = "true"
    Role      = "vpn"
  }
}
variable "public_subnets_count" {
  description = "The number of public subnets"
  type        = number
  default     = 2
}

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = true
}

variable "ami_id" {
  type    = string
  default = "ami-01ed8ade75d4eee2f"
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "allowed_cidr_blocks" {
  description = "Addresses to allow access to"
  type        = list(string)
  default     = []
}
