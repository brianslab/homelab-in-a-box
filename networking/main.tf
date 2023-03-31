# --- networking/main.tf --- #

data "aws_availability_zones" "available" {}

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "random_shuffle" "avail_zone_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

resource "aws_vpc" "hiab_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "hiab_vpc-${random_integer.random.id}"
  }
}

resource "aws_subnet" "hiab_public_subnet" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.hiab_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.avail_zone_list.result[count.index]

  tags = {
    Name = "hiab_public_${count.index + 1}"
  }
}

resource "aws_subnet" "hiab_private_subnet" {
  count                   = var.private_subnet_count
  vpc_id                  = aws_vpc.hiab_vpc.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = random_shuffle.avail_zone_list.result[count.index]

  tags = {
    Name = "hiab_private_${count.index + 1}"
  }
}
