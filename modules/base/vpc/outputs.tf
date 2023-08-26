output "vpc_ids" {
  description = "IDs of VPCs"
  # value       = aws_vpc.region1[*].id
  value = [for instance in aws_vpc.region1: instance.id ]
}
