variable "vpc_cidr" {}
variable "aws_region" {}

resource "aws_vpc" "hub" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags                 = { Name = "Hub-VPC" }
}

# 1. Add the Internet Gateway
resource "aws_internet_gateway" "hub_igw" {
  vpc_id = aws_vpc.hub.id
  tags   = { Name = "Hub-Internet-Gateway" }
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.hub.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags              = { Name = "Hub-Public-Subnet-A" }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.hub.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}b"
  map_public_ip_on_launch = true
  tags              = { Name = "Hub-Public-Subnet-B" }
}

# 2. Create a Route Table directing traffic to the Internet Gateway
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.hub.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hub_igw.id
  }
  tags = { Name = "Hub-Public-RouteTable" }
}

# 3. Associate the Route Table with BOTH subnets
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rt.id
}

