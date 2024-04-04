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

resource "aws_instance" "region_1" {
  count = var.instance_count
  ami = var.aws_ami
  monitoring = var.ec2_monitoring
  instance_type = var.instance_t
  subnet_id = var.subnet_ids[count.index]
  tags = {
    Name = var.vpc_region1[count.index]
  }
}
