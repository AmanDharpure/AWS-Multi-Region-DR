variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}

variable "application_port" {
  description = "Application port"
  type        = number
  default     = 80
}

variable "database_port" {
  description = "PostgreSQL port"
  type        = number
  default     = 5432
}