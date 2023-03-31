# --- root/variables.tf --- #

variable "aws_region" {
  default = "us-west-2"
}

variable "access_ip" {
  type = string
}

variable "db_password" {
  type = string
}