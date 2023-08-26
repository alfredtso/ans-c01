terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  profile = "acg"
}

resource "aws_vpc" "aws_vpc_1" {
  cidr_block = "10.19.0.0/16"
  tags = {
    Name = "demo-vpc"
  }
}

# Subnet
resource "aws_subnet" "private_a" {
  vpc_id = aws_vpc.aws_vpc_1.id
  cidr_block = "10.19.10.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "public_a" {
  vpc_id = aws_vpc.aws_vpc_1.id
  cidr_block = "10.19.0.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "private_c" {
  vpc_id = aws_vpc.aws_vpc_1.id
  cidr_block = "10.19.12.0/24"
  availability_zone = "us-east-1c"
}

resource "aws_subnet" "public_c" {
  vpc_id = aws_vpc.aws_vpc_1.id
  cidr_block = "10.19.2.0/24"
  availability_zone = "us-east-1c"
}

resource "aws_subnet" "mgmt_c" {
  vpc_id = aws_vpc.aws_vpc_1.id
  cidr_block = "10.19.14.0/24"
  availability_zone = "us-east-1c"
}

# 1-to-1 route table
resource "aws_route_table" "private_a_rt" {
  vpc_id = aws_vpc.aws_vpc_1.id
  tags = {
    Name = "Private Subnet AZ A" 
  }
}

resource "aws_route_table" "public_a_rt" {
  vpc_id = aws_vpc.aws_vpc_1.id
  tags = {
    Name = "Public Subnet AZ A" 
  }
}

resource "aws_route_table" "private_c_rt" {
  vpc_id = aws_vpc.aws_vpc_1.id
  tags = {
    Name = "Private Subnet AZ C" 
  }
}

resource "aws_route_table" "public_c_rt" {
  vpc_id = aws_vpc.aws_vpc_1.id
  tags = {
    Name = "Public Subnet AZ C" 
  }
}

resource "aws_route_table" "mgmt_c_rt" {
  vpc_id = aws_vpc.aws_vpc_1.id
  tags = {
    Name = "Managment Subnet AZ C" 
  }
}

# Route table association

resource "aws_route_table_association" "pri_a" {
  subnet_id = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a_rt.id
}
resource "aws_route_table_association" "pri_c" {
  subnet_id = aws_subnet.private_c.id
  route_table_id = aws_route_table.private_c_rt.id
}
resource "aws_route_table_association" "pub_a" {
  subnet_id = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_a_rt.id
}
resource "aws_route_table_association" "pub_c" {
  subnet_id = aws_subnet.public_c.id
  route_table_id = aws_route_table.public_c_rt.id
}
resource "aws_route_table_association" "mgmt_c" {
  subnet_id = aws_subnet.mgmt_c.id
  route_table_id = aws_route_table.mgmt_c_rt.id
}

# Security Group
resource "aws_security_group" "allow_http" {
  name = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id = aws_vpc.aws_vpc_1.id

  ingress {
    description = "HTTP from VPC"
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }
}

resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  description = "Allow SSH within vpc"
  vpc_id = aws_vpc.aws_vpc_1.id

  ingress {
    description = "SSH within VPC"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [aws_vpc.aws_vpc_1.cidr_block]
  }
}

