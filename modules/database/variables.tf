variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "database_subnet_ids" {
  description = "Subnet IDs used by the RDS subnet group"
  type        = list(string)
}

variable "database_security_group_id" {
  description = "Security group ID for the database"
  type        = string
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Database storage in GB"
  type        = number
  default     = 20
}

variable "database_name" {
  description = "Initial PostgreSQL database name"
  type        = string
  default     = "appdb"
}

variable "master_username" {
  description = "Database master username"
  type        = string
  default     = "dbadmin"
}