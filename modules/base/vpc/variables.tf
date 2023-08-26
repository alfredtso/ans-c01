variable "vpc_region1" {
  description = "Create 3 VPCs with these names"
  type        = list(string)
  default     = ["public_1",
                 "private1_1",
                 "private2_1"
                ]
}

variable "vpc_cidr_blocks" {
  description = "Create 3 VPCs with these CIDR blocks"
  type        = list(string)
  default     = ["10.19.0.0/16",
                 "10.20.0.0/16",
                 "10.21.0.0/16"
                 ]
}
