# --- root/locals.tf --- #

locals {
  vpc_cidr = "10.222.0.0/16"
}

locals {
  security_groups = {
    public = {
      name        = "public_security_group"
      description = "Security Group for Public Access"
      ingress = {
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
      }
    }
  }
}
