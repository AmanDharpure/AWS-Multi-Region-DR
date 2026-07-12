variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "source_db_arn" {
  description = "ARN of the Primary RDS instance"
  type        = string
}

variable "database_subnet_ids" {
  description = "Private subnet IDs for the DR database"
  type        = list(string)
}

variable "database_security_group_id" {
  description = "Security group ID for the DR database"
  type        = string
}

variable "kms_key_arn" {
  description = "KMS key ARN used to encrypt the DR replica"
  type        = string
}

variable "instance_class" {
  description = "RDS replica instance class"
  type        = string
  default     = "db.t3.micro"
}