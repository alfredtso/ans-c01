terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "aws_availability_zones" "available" {}

locals {
  //azs = slice(data.aws_availability_zones.available.names, 0, 3)
  azs = [ "us-east-1a", "us-east-1b" ]
}

module "alb" {
  source = "terraform-aws-modules/alb/aws"
  version = "9.8.0"

  subnets = [ module.vpc.public_subnets[0], module.vpc.public_subnets[1] ]
  enable_deletion_protection = false

  security_groups = [ module.vpc.default_security_group_id ]
  create_security_group = false
  security_group_ingress_rules = {
  all_https = {
    from_port   = 443
    to_port     = 443
    ip_protocol = "tcp"
    description = "HTTPS web traffic"
    cidr_ipv4   = "0.0.0.0/0"
    }
  }
}

resource "aws_lb_listener" "testing" {
  load_balancer_arn = module.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn = aws_iam_server_certificate.test_cert.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Hello world"
      status_code  = "200"
    }
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  azs = local.azs
  public_subnets = [ "10.0.1.0/24", "10.0.2.0/24" ]
}

module "ec2_b" {
  source = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name = "instance-web_b"
  instance_count = 1
  instance_type = "t2.micro"
  monitoring = true
  vpc_security_group_ids = [ module.vpc.default_security_group_id ]
  subnet_id = module.vpc.public_subnets[1]
  ami = "ami-06c68f701d8090592"
} 

module "ec2_a" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  for_each = toset(["admin", "web_a"])

  name = "instance-${each.key}"

  instance_type          = "t2.micro"
  monitoring             = true
  vpc_security_group_ids = [ module.vpc.default_security_group_id ]
  subnet_id              = module.vpc.public_subnets[0]
  ami                    = "ami-06c68f701d8090592"
  user_data              = file("server.sh")
}



resource "aws_iam_server_certificate" "test_cert" {
  name             = "some_test_cert"
  certificate_body = file("cert.pem")
  private_key      = file("privatekey.pem")
}

