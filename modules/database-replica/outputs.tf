output "replica_identifier" {
  value = aws_db_instance.replica.identifier
}

output "replica_endpoint" {
  value = aws_db_instance.replica.endpoint
}