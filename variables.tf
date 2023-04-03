# --- root/variables.tf --- #

variable "aws_region" {
  default = "us-west-2"
}

# Networking variables
variable "access_ip" {
  type = string
}

# DB variables
variable "db_name" {
  type = string
}

variable "db_user" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}

# Compute variables
variable "rancher_token" {
  type      = string
  sensitive = true
}
