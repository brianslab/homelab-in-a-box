# --- networking/variables.tf --- #

variable "access_ip" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "security_groups" {}

variable "public_subnet_count" {
  type = number
}

variable "private_subnet_count" {
  type = number
}

variable "max_subnets" {
  type = number
}

variable "public_cidrs" {
  type = list(string)
}

variable "private_cidrs" {
  type = list(string)
}

variable "make_db_subnet_group" {
  type = bool
}
