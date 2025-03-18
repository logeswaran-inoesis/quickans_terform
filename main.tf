provider "aws" {
  region = "ap-south-1" # Change as per your requirement
}

resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "eks_vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public-RT"
  }
}

resource "aws_subnet" "subnet_01" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.subnet01_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "subnet-01"
  }
}

resource "aws_subnet" "subnet_02" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.subnet02_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "subnet-02"
  }
}

resource "aws_subnet" "subnet_03" {
  count             = length(data.aws_availability_zones.available.names) > 2 ? 1 : 0
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.subnet03_cidr
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
    Name = "subnet-03"
  }
}

resource "aws_route_table_association" "rta_subnet_01" {
  subnet_id      = aws_subnet.subnet_01.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "rta_subnet_02" {
  subnet_id      = aws_subnet.subnet_02.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "rta_subnet_03" {
  count          = length(data.aws_availability_zones.available.names) > 2 ? 1 : 0
  subnet_id      = aws_subnet.subnet_03[0].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "eks_control_plane_sg" {
  name        = "eks-control-plane-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.eks_vpc.id
}

data "aws_availability_zones" "available" {}
