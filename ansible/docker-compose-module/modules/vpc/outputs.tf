output "private_subnets" {
  description = "The private subnets of the VPC"
  value       = module.vpc.private_subnets
}
output "public_subnets" {
  description = "The public subnets of the VPC"
  value       = module.vpc.public_subnets
}
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}
output "rds_security_group_ids" {
  description = "output from rds module"
  value       = [aws_security_group.rds_security_group.id]
}

output "rds_subnet_group_ids" {
  description = "output from rds module"
  value       = [aws_db_subnet_group.rds_subnet_group.id]
}

# output "private_subnets" {
#   description = "The private subnets of the VPC"
#   value       = module.vpc.private_subnets
# }
