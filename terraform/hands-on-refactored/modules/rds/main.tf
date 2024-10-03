module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.9.0"

  identifier = var.db_name

  engine            = "mysql"
  engine_version    = "8.0"
  major_engine_version = "8.0"
  # DB parameter group
  family = "mysql8.0"
  instance_class    = "db.t2.micro"
  allocated_storage = 5
  db_name   = var.db_name
  username = var.database_user
  password = var.database_password
  port     = var.database_port

  iam_database_authentication_enabled = true

  vpc_security_group_ids = var.vpc_security_group_ids

  maintenance_window = var.maintenance_window
  backup_window      = var.backup_window

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval    = var.monitoring_interval
  monitoring_role_name   = var.monitoring_role_name
  create_monitoring_role = var.create_monitoring_role

  tags = {
    Environment = var.rds_tags_environment
  }

  # DB subnet group
  subnet_ids = var.subnet_ids

  # Database Deletion Protection
  deletion_protection = false
}