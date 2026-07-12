output "replica_identifier" {
  description = "DR RDS replica identifier"
  value       = aws_db_instance.replica.identifier
}

output "replica_endpoint" {
  description = "DR RDS replica endpoint"
  value       = aws_db_instance.replica.endpoint
}