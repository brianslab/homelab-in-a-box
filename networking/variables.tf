# --- networking/variables.tf --- #

variable "vpc_cidr" {
  type = string
}

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

variable "access_ip" {
  type = string
}
