# --- loadbalancing/main.tf --- #

resource "aws_lb" "hiab_loadbalancer" {
  name            = "hiab-loadbalancer"
  subnets         = var.public_subnets
  security_groups = [var.public_security_group]
  idle_timeout    = 400
}

resource "aws_lb_target_group" "hiab_target_group" {
  name     = "hiab-lb-target-group-${substr(uuid(), 0, 3)}"
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id
  health_check {
    healthy_threshold   = var.lb_healthy_threshold
    unhealthy_threshold = var.lb_unhealthy_threshold
    timeout             = var.lb_timeout
    interval            = var.lb_interval
  }
  lifecycle {
    ignore_changes        = [name]
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "hiab_lb_listener" {
  load_balancer_arn = aws_lb.hiab_loadbalancer.arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hiab_target_group.arn
  }
}
