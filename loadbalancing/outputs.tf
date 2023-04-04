# --- loadbalancing/outputs.tf --- #

output "lb_target_group_arn" {
  value = aws_lb_target_group.hiab_target_group.arn
}

output "lb_endpoint" {
  value = aws_lb.hiab_loadbalancer.dns_name
}
