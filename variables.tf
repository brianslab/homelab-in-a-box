# --- root/variables.tf --- #

variable "aws_region" {
  default = "us-west-2"
}

# Networking variables
variable "access_ip" {
  type = string
}
