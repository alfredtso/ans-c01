output "vpc_region1_id" {
  description = " IDs of the VPCs"
  value       = module.a_bunch_of_vpc.vpc_ids
}

output "subnet_region1_id" {
  description = " IDs of the Subnets"
  value       = module.a_bunch_of_subnet.subnet_ids
}

