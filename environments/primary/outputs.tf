output "vpc_id" {
  description = "Primary VPC ID"
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "Primary public subnet IDs"
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Primary private subnet IDs"
  value       = module.networking.private_subnet_ids
}
output "alb_dns_name" {
  description = "Primary Application Load Balancer DNS name"
  value       = module.alb.load_balancer_dns_name
}
output "autoscaling_group_name" {
  value = module.compute.autoscaling_group_name
}

output "launch_template_id" {
  value = module.compute.launch_template_id
}