variable "subnet_ids" {
  description = "The subnets in which these EC2 will be"
}

variable "vpc_region1" {
  description = "Create 3 VPCs with these names"
  type        = list(string)
  default     = ["public_1",
                 "private1_1",
                 "private2_1"
                ]
}

variable "instance_count" {}

variable "ec2_monitoring" {
  description = "If detailed monitoring is enabled"
  default = false
}

variable "aws_ami" {
  type = string
  default = "ami-04cb4ca688797756f"
}

variable "instance_t" {
  type = string
  default = "t2.micro"

}
