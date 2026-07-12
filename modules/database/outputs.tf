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