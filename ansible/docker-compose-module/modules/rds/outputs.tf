output "rds_endpoint" {
  description = "output from rds endpoint"
  value       = [module.db.db_instance_endpoint]
}
