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

  lifecycle {
    create_before_destroy = true
  }

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

resource "aws_route_table_association" "hiab_public_assoc" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.hiab_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.hiab_public_route_table.id
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

resource "aws_internet_gateway" "hiab_internet_gateway" {
  vpc_id = aws_vpc.hiab_vpc.id

  tags = {
    Name = "hiab_gateway"
  }
}

resource "aws_route_table" "hiab_public_route_table" {
  vpc_id = aws_vpc.hiab_vpc.id

  tags = {
    Name = "hiab_public"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.hiab_public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.hiab_internet_gateway.id
}

resource "aws_default_route_table" "hiab_private_route_table" {
  default_route_table_id = aws_vpc.hiab_vpc.default_route_table_id

  tags = {
    Name = "hiab_private"
  }
}

resource "aws_security_group" "hiab_sec_group" {
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.hiab_vpc.id
  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "hiab_rds_subnet_group" {
  count      = var.make_db_subnet_group ? 1 : 0
  name       = "hiab_rds_subnet_group"
  subnet_ids = aws_subnet.hiab_private_subnet.*.id

  tags = {
    Name = "hiab_rds_subnet_group"
  }
}
