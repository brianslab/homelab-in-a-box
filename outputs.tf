# --- root/outputs.tf --- #

output "loadbalancer_endpoint" {
  value = module.loadbalancing.lb_endpoint
}

output "instances" {
  value = { for i in module.compute.instance : i.tags.Name => i.public_ip }
}
