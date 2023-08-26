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
  profile = "default"
}

resource "aws_vpc" "region1" {
  count = length(var.vpc_region1)
  cidr_block = var.vpc_cidr_blocks[count.index]
  tags = {
    Name = var.vpc_region1[count.index]
  }
}
