# --- root/main.tf --- #

module "networking" {
  source               = "./networking"
  access_ip            = var.access_ip
  vpc_cidr             = local.vpc_cidr
  security_groups      = local.security_groups
  public_subnet_count  = 2
  private_subnet_count = 3
  max_subnets          = 20
  public_cidrs         = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidrs        = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  make_db_subnet_group = true
}

module "database" {
  source                 = "./database"
  db_storage             = 20
  db_engine_version      = "5.7.41"
  db_instance_class      = "db.t2.micro"
  db_name                = var.db_name
  db_user                = var.db_user
  db_password            = var.db_password
  db_subnet_group_name   = module.networking.db_subnet_group_name[0]
  vpc_security_group_ids = module.networking.db_security_group
  db_identifier          = "hiab-db"
  skip_db_snapshot       = true
}
