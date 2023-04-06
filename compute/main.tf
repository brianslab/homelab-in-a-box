# --- compute/main.tf --- #

data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "random_id" "hiab_node_id" {
  byte_length = 2
  count       = var.instance_count
  keepers = {
    key_name = var.key_name
  }
}

resource "aws_key_pair" "hiab_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "hiab_node" {
  count                  = var.instance_count
  instance_type          = var.instance_type
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.hiab_auth.id
  vpc_security_group_ids = [var.public_security_group]
  subnet_id              = var.public_subnet
  user_data = templatefile(var.user_data_path,
    {
      nodename      = "hiab-node-${random_id.hiab_node_id[count.index].dec}"
      db_endpoint   = var.db_endpoint
      db_name       = var.db_name
      db_user       = var.db_user
      db_password   = var.db_password
      rancher_token = var.rancher_token
    }
  )
  root_block_device {
    volume_size = var.vol_size
  }

  tags = {
    Name = "hiab-node-${random_id.hiab_node_id[count.index].dec}"
  }
}

resource "aws_lb_target_group_attachment" "hiab_target_group_attachment" {
  count            = var.instance_count
  target_group_arn = var.lb_target_group_arn
  target_id        = aws_instance.hiab_node[count.index].id
  port             = var.target_group_port
}
