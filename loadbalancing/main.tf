# --- loadbalancing/main.tf --- #

resource "aws_lb" "hiab_loadbalancer" {
  name            = "hiab-loadbalancer"
  subnets         = var.public_subnets
  security_groups = [var.public_security_group]
  idle_timeout    = 400
}
