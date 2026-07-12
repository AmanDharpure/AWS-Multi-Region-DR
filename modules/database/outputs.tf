output "db_instance_identifier" {
  description = "RDS instance identifier"
  value       = aws_db_instance.primary.identifier
}

output "db_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.primary.endpoint
}

output "db_subnet_group_name" {
  description = "Database subnet group"
  value       = aws_db_subnet_group.main.name
}
output "db_instance_arn" {
  description = "ARN of the primary RDS instance"
  value       = aws_db_instance.primary.arn
}