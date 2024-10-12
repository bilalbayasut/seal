variable "key_name" {
  description = "key_name"
  type        = string
}

# rds
variable "rds_tags_environment" {
  description = "rds_tags_environment"
  type        = string
}

variable "db_name" {
  description = "database name"
  type        = string
}

variable "username" {
  description = "database user"
  type        = string
}

variable "password" {
  description = "database_password"
  type        = string
}

variable "port" {
  description = "database_port"
  type        = string
}
variable "maintenance_window" {
  description = "maintenance_window"
  type        = string
  default     = "Mon:00:00-Mon:03:00"
}
variable "backup_window" {
  description = "backup_window"
  type        = string
}
variable "monitoring_interval" {
  description = "monitoring_interval"
  type        = string
}
variable "monitoring_role_name" {
  description = "monitoring_role_name"
  type        = string
}
variable "create_monitoring_role" {
  description = "create_monitoring_role"
  type        = string
}
variable "subnet_ids" {
  description = "subnet_ids"
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "vpc_security_group_ids"
  type        = list(string)
}

variable "db_subnet_group_name" {
  description = "db_subnet_group_name"
  type        = string
}
