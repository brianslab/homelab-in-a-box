# --- compute/outputs.tf --- #

output "instance" {
  value = aws_instance.hiab_node[*]
}