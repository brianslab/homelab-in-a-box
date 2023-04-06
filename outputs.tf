# --- root/outputs.tf --- #

output "loadbalancer_endpoint" {
  value = module.loadbalancing.lb_endpoint
}

output "ansible_control_node" {
  value = module.ansible_control_node.instance.public_ip
  sensitive = true
}

output "instances" {
  value     = { for i in module.compute.instance : i.tags.Name => i.public_ip }
  sensitive = true
}
