# --- networking/outputs.tf --- #

output "vpc_id" {
  value = aws_vpc.hiab_vpc.id
}
