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

module "loadbalancing" {
  source                 = "./loadbalancing"
  public_subnets         = module.networking.public_subnets
  public_security_group  = module.networking.public_security_group
  target_group_port      = 8000
  target_group_protocol  = "HTTP"
  vpc_id                 = module.networking.vpc_id
  lb_healthy_threshold   = 2
  lb_unhealthy_threshold = 2
  lb_timeout             = 3
  lb_interval            = 30
  listener_port          = 80
  listener_protocol      = "HTTP"
}

resource "aws_key_pair" "hiab_auth" {
  key_name   = "hiab_artemis"
  public_key = file("/home/brian/.ssh/hiab_artemis.pub")
}

module "compute" {
  source                = "./compute"
  instance_count        = 5
  instance_type         = "t3.micro"
  public_security_group = module.networking.public_security_group
  public_subnet         = module.networking.public_subnets[1]
  vol_size              = 10
  key_name              = aws_key_pair.hiab_auth.id
  user_data_path        = "${path.root}/userdata_k3s.tpl"
  db_name               = var.db_name
  db_user               = var.db_user
  db_password           = var.db_password
  db_endpoint           = module.database.db_endpoint
  rancher_token         = var.rancher_token
  lb_target_group_arn   = module.loadbalancing.lb_target_group_arn
  target_group_port     = 8000
}

module "ansible_control_node" {
  source                = "./ansible_control_node"
  instance_type         = "t3.micro"
  public_security_group = module.networking.public_security_group
  public_subnet         = module.networking.public_subnets[0]
  vol_size              = 30
  key_name              = aws_key_pair.hiab_auth.id
  user_data_path        = "${path.root}/userdata_acn.tpl"
}
