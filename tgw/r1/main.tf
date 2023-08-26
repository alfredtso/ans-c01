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
  region  = "us-east-1"
  profile = "default"
}

module "a_bunch_of_vpc" {
  source = "../../modules/base/vpc"
}

module "a_bunch_of_subnet" {
  source = "../../modules/base/subnet"
  vpc_id = module.a_bunch_of_vpc.vpc_ids
}
