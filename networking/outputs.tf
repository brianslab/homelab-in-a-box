# --- networking/outputs.tf --- #

output "vpc_id" {
  value = aws_vpc.hiab_vpc.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.hiab_rds_subnet_group.*.name
}

output "db_security_group" {
  value = [aws_security_group.hiab_sec_group["rds"].id]
}

output "public_subnets" {
  value = aws_subnet.hiab_public_subnet.*.id
}

output "public_security_group" {
  value = aws_security_group.hiab_sec_group["public"].id
}
