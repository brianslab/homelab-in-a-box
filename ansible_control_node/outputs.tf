# --- ansible_control_node/main.tf --- #

output "instance" {
  value     = aws_instance.hiab_ansible_control_node
  sensitive = true
}
