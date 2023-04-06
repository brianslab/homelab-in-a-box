# --- ansible_control_node/main.tf --- #

data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "hiab_ansible_control_node" {
  instance_type          = var.instance_type
  ami                    = data.aws_ami.server_ami.id
  key_name               = var.key_name
  vpc_security_group_ids = [var.public_security_group]
  subnet_id              = var.public_subnet
  user_data              = templatefile(var.user_data_path, { hostname = "hiab-acn" })
  root_block_device {
    volume_size = var.vol_size
  }

  tags = {
    Name = "hiab-ansible-control-node"
  }
}

# resource "aws_lb_target_group_attachment" "hiab_target_group_attachment" {
#   target_group_arn = var.lb_target_group_arn
#   target_id        = aws_instance.hiab_node[count.index].id
#   port             = var.target_group_port
# }
