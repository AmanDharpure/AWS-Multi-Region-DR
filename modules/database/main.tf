locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

resource "aws_db_subnet_group" "main" {
  name       = "${lower(local.name_prefix)}-db-subnet-group"
  subnet_ids = var.database_subnet_ids

  tags = {
    Name = "${lower(local.name_prefix)}-db-subnet-group"
  }
}

resource "aws_db_instance" "primary" {
  identifier = "${lower(local.name_prefix)}-postgres"

  engine         = "postgres"
  engine_version = "17"

  instance_class        = var.instance_class
  allocated_storage     = var.allocated_storage
  max_allocated_storage = 50
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.database_name
username = var.master_username
password = var.master_password
  db_subnet_group_name = aws_db_subnet_group.main.name

  vpc_security_group_ids = [
    var.database_security_group_id
  ]

  publicly_accessible = false
  multi_az            = false

  backup_retention_period = 1
  copy_tags_to_snapshot    = true

  deletion_protection = false
  skip_final_snapshot = true

  auto_minor_version_upgrade = true
  apply_immediately          = true

  tags = {
    Name = "${lower(local.name_prefix)}-postgres"
  }
}