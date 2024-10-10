output "vpc" {
  description = "output from vpc module"
  value       = module.vpc
}

output "rds" {
  description = "output from rds module"
  value       = module.rds
}
