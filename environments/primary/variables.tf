variable "project_name" {
  default = "AWS-Multi-Region-DR"
}

variable "environment" {
  default = "primary"
}

variable "region" {
  default = "us-east-1"
}
variable "master_password" {
  description = "Primary RDS master password"
  type        = string
  sensitive   = true
}
variable "notification_email" {
  description = "Email address for CloudWatch and SNS alerts"
  type        = string
}