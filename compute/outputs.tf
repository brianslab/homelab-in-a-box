# --- compute/outputs.tf --- #

output "instance" {
  value = aws_instance.hiab_node[*]
}

output "instance_port" {
  value = aws_lb_target_group_attachment.hiab_target_group_attachment[0].port
}
