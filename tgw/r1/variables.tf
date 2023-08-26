variable "vpc_region1" {
  description = "Create 3 VPCs with these names"
  type        = list(string)
  default     = ["public_1", "private1_1", "private2_1"]
}
