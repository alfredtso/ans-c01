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

resource "aws_subnet" "region1_subnets" {
  count      = length(var.subnets_region1)
  vpc_id     = var.vpc_id[count.index]
  cidr_block = var.subnet_cidr_blocks[count.index]
  tags = {
    Name = var.subnets_region1[count.index]
  }
}
