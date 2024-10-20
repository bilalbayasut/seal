module "vpc" {
  source             = "./modules/vpc"
  vpc_name           = var.vpc_name
  env                = var.env
  key_name           = var.key_name
  cidr               = var.cidr
  azs                = var.azs
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  enable_nat_gateway = var.enable_nat_gateway
  enable_vpn_gateway = var.enable_vpn_gateway
}
module "rds" {
  source                 = "./modules/rds"
  depends_on             = [module.vpc]
  create_monitoring_role = false
  db_name                = var.db_name
  password               = var.password
  username               = var.username
  port                   = var.port
  rds_tags_environment   = var.env
  backup_window          = "03:00-06:00"
  monitoring_role_name   = "MyRDSMonitoringRole"
  monitoring_interval    = "30"
  maintenance_window     = "Mon:00:00-Mon:03:00"
  key_name               = var.key_name
  vpc_security_group_ids = module.vpc.rds_security_group_ids
  subnet_ids             = module.vpc.private_subnets
  db_subnet_group_name   = "rds-subnet-group"

}

# generate .env for ansible
resource "local_file" "env_file" {
  content  = <<EOT
wordpress_db_host: ${split(":", module.rds.rds_endpoint[0])[0]}
wordpress_db_user: ${var.username}
wordpress_db_password: ${var.password}
wordpress_db_name: ${var.db_name}
EOT
  filename = "${path.module}/env.yml"
}

# execute ansible command
resource "null_resource" "execute_ansible" {
  depends_on = [module.rds, module.vpc]
  provisioner "remote-exec" {
    connection {
      host        = module.vpc.aws_instance_public_ip
      user        = "ubuntu"
      private_key = file("${path.module}/${var.key_name}.pem")
    }

    inline = ["echo 'connected!'"]
  }

  provisioner "local-exec" {
    command     = "ansible-playbook ./playbooks/install_docker_wordpress.yml --extra-vars '@env.yml'"
    working_dir = path.module
  }
}

# Outputs (Optional)
output "db_host" {
  value = module.rds.rds_endpoint
}

output "wordpress_url" {
  value = "http://${module.vpc.aws_instance_public_ip}"
}
