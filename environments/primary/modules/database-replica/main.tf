locals {
  name_prefix = lower("${var.project_name}-${var.environment}")
}

resource "aws_db_subnet_group" "replica" {
  name       = "${local.name_prefix}-db-subnet-group"
  subnet_ids = var.database_subnet_ids

  tags = {
    Name = "${local.name_prefix}-db-subnet-group"
  }
}

resource "aws_db_instance" "replica" {
  identifier = "${local.name_prefix}-postgres-replica"

  replicate_source_db = var.source_db_arn
  instance_class      = var.instance_class

  db_subnet_group_name = aws_db_subnet_group.replica.name

  vpc_security_group_ids = [
    var.database_security_group_id
  ]

  storage_encrypted = true
  kms_key_id        = var.kms_key_arn

  publicly_accessible = false

  backup_retention_period = 1

  auto_minor_version_upgrade = true
  apply_immediately          = true

  skip_final_snapshot = true

  tags = {
    Name = "${local.name_prefix}-postgres-replica"
  }
}