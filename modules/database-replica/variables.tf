variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "source_db_arn" {
  type = string
}

variable "database_subnet_ids" {
  type = list(string)
}

variable "database_security_group_id" {
  type = string
}

variable "kms_key_arn" {
  type = string
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}