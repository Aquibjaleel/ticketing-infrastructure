variable "vpc_cidr" {}
variable "private_subnet_cidr_a" { default = "10.1.0.0/20" }
variable "private_subnet_cidr_b" { default = "10.1.16.0/20" }
variable "aws_region" {}

resource "aws_vpc" "spoke" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags                 = { Name = "Spoke-VPC" }
}

# Private Subnet A
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.spoke.id
  cidr_block        = var.private_subnet_cidr_a
  availability_zone = "${var.aws_region}a"
  tags              = { Name = "EKS-Node-Subnet-A" }
}

# Private Subnet B
resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.spoke.id
  cidr_block        = var.private_subnet_cidr_b
  availability_zone = "${var.aws_region}b"
  tags              = { Name = "EKS-Node-Subnet-B" }
}

# Change the output to pass BOTH subnets to EKS
