output "dr_vpc_id" {
  description = "DR VPC ID"
  value       = module.networking.vpc_id
}

output "dr_public_subnet_ids" {
  description = "DR public subnet IDs"
  value       = module.networking.public_subnet_ids
}

output "dr_private_subnet_ids" {
  description = "DR private subnet IDs"
  value       = module.networking.private_subnet_ids
}

output "dr_alb_dns_name" {
  description = "DR Application Load Balancer DNS name"
  value       = module.alb.load_balancer_dns_name
}

output "dr_autoscaling_group_name" {
  description = "DR Auto Scaling Group name"
  value       = module.compute.autoscaling_group_name
}

output "dr_database_security_group_id" {
  description = "Security group for the future DR database replica"
  value       = module.security.database_security_group_id
}
output "dr_database_replica_identifier" {
  description = "DR PostgreSQL replica identifier"
  value       = module.database_replica.replica_identifier
}

output "dr_database_replica_endpoint" {
  description = "DR PostgreSQL replica endpoint"
  value       = module.database_replica.replica_endpoint
}
output "failover_lambda_name" {
  description = "DR failover Lambda function name"
  value       = module.failover_lambda.lambda_function_name
}

output "failover_lambda_arn" {
  description = "DR failover Lambda function ARN"
  value       = module.failover_lambda.lambda_function_arn
}