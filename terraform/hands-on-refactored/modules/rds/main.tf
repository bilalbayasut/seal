module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.9.0"

  identifier = var.db_name

  engine               = "mysql"
  engine_version       = "8.0"
  major_engine_version = "8.0"
  # DB parameter group
  family              = "mysql8.0"
  instance_class      = "db.t3.micro"
  allocated_storage   = 5
  skip_final_snapshot = true
  db_name             = var.db_name
  username            = var.username
  password            = var.password
  port                = var.port

  iam_database_authentication_enabled = false
  storage_encrypted                   = false
  manage_master_user_password         = false

  vpc_security_group_ids = var.vpc_security_group_ids

  maintenance_window = var.maintenance_window
  backup_window      = var.backup_window

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  # monitoring_interval    = var.monitoring_interval
  # monitoring_role_name   = var.monitoring_role_name
  # create_monitoring_role = var.create_monitoring_role

  tags = {
    Environment = var.rds_tags_environment
  }

  # DB subnet group
  subnet_ids = var.subnet_ids

  db_subnet_group_name = var.db_subnet_group_name

  # Database Deletion Protection
  deletion_protection = false
}
