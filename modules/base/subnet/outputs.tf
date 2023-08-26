output "subnet_ids" {
  description = "IDs of subnets"
  value = [for instance in aws_subnet.region1_subnets: instance.id ]
}
