# --- compute/variables.tf --- #

variable "instance_count" {}
variable "instance_type" {}
variable "public_security_group" {}
variable "public_subnet" {}
variable "vol_size" {}
variable "key_name" {}
variable "public_key_path" {}
variable "user_data_path" {}
variable "db_name" {}
variable "db_user" {}
variable "db_password" {}
variable "db_endpoint" {}
variable "rancher_token" {}
variable "lb_target_group_arn" {}
variable "target_group_port" {}
