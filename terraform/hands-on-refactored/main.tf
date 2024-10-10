module "vpc" {
  source                = "./modules/vpc"
  vpc_name = var.vpc_name
  env=var.env
  key_name=var.key_name
  cidr = var.cidr
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  enable_nat_gateway = var.enable_nat_gateway
  enable_vpn_gateway = var.enable_vpn_gateway
}
module "rds" {
  source                = "./modules/rds"
  depends_on             = [module.vpc]
  create_monitoring_role = true
  db_name = var.database_name
  database_password = var.database_password
  database_port = var.database_port
  database_user = var.database_user
  rds_tags_environment = var.env
  backup_window = "03:00-06:00"
  monitoring_role_name = "MyRDSMonitoringRole"
  monitoring_interval = "30"
  maintenance_window = "Mon:00:00-Mon:03:00"
  key_name = var.key_name
  vpc_security_group_ids = module.vpc.vpc_security_group_ids
  subnet_ids = module.vpc.private_subnets

  # dentifier = var.database_name
  # # engine            = "mysql"
  # # engine_version    = "8.0"
  # # instance_class    = "db.t2.micro"
  # # allocated_storage = 5

  # name     = var.database_name
  # username = var.database_user
  # password = var.database_password
  # port     = var.database_port

  # iam_database_authentication_enabled = true

  # vpc_security_group_ids = var.vpc_security_group_ids

  # maintenance_window = "Mon:00:00-Mon:03:00"
  # backup_window      = "03:00-06:00"

  # # Enhanced Monitoring - see example for details on how to create the role
  # # by yourself, in case you don't want to create it automatically
  # monitoring_interval    = "30"
  # monitoring_role_name   = "MyRDSMonitoringRole"
  # create_monitoring_role = true

  # tags = {
  #   Environment = var.rds_tags_environment
  # }

  # # DB subnet group
  # subnet_ids = var.subnet_ids
}