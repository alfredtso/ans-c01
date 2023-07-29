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
}

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
