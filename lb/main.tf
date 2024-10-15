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
}


resource "aws_lb_target_group" "https" {
  name     = "alb-tg-https"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTPS"
    timeout             = 5
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "a" {
  for_each = {
    for k, v in module.ec2_a : k => v
  }

  target_group_arn = aws_lb_target_group.https.arn
  target_id        = each.value.id
  port             = 443
}

resource "aws_lb_target_group_attachment" "b" {
  target_group_arn = aws_lb_target_group.https.arn
  target_id        = module.ec2_b.id[0]
  port             = 443
}

resource "aws_lb_listener" "testing" {
  load_balancer_arn = module.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn = aws_iam_server_certificate.test_cert.arn

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.https.arn
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  azs = local.azs
  public_subnets = [ "10.0.1.0/24", "10.0.2.0/24" ]
}

resource "aws_vpc_security_group_ingress_rule" "https_in" {
  security_group_id = module.vpc.default_security_group_id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

module "ec2_b" {
  source = "terraform-aws-modules/ec2-instance/aws"

  key_name = module.key_pair.key_pair_name

  name = "instance-web_b"
  instance_count = 1
  instance_type = "t2.micro"
  monitoring = true
  vpc_security_group_ids = [ module.vpc.default_security_group_id ]
  subnet_id = module.vpc.public_subnets[1]
  ami = "ami-06c68f701d8090592"
  user_data = file("server_b.sh")
} 

module "ec2_a" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  for_each = toset(["admin", "web_a"])
  key_name = module.key_pair.key_pair_name

  name = "instance-${each.key}"

  instance_type          = "t2.micro"
  monitoring             = true
  vpc_security_group_ids = [ module.vpc.default_security_group_id ]
  subnet_id              = module.vpc.public_subnets[0]
  ami                    = "ami-06c68f701d8090592"
  user_data              = templatefile("server.tfpl", 
    {
        server_name = "WebA"
    })
}



resource "aws_iam_server_certificate" "test_cert" {
  name             = "some_test_cert"
  certificate_body = file("cert.pem")
  private_key      = file("privatekey.pem")
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = "my-key-pair"
  public_key = file("./id_ed25519.pub")
}

