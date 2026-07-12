variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "notification_email" {
  description = "Email address that receives monitoring alerts"
  type        = string
}

variable "load_balancer_arn_suffix" {
  description = "ALB ARN suffix used by CloudWatch"
  type        = string
}

variable "target_group_arn_suffix" {
  description = "Target-group ARN suffix used by CloudWatch"
  type        = string
}

variable "autoscaling_group_name" {
  description = "Application Auto Scaling Group name"
  type        = string
}

variable "database_identifier" {
  description = "RDS database identifier"
  type        = string
}