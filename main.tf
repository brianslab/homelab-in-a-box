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
