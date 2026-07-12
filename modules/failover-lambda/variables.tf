variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "dr_region" {
  description = "AWS disaster recovery Region"
  type        = string
  default     = "us-west-2"
}

variable "dr_asg_name" {
  description = "DR Auto Scaling Group name"
  type        = string
}

variable "dr_replica_identifier" {
  description = "DR RDS read replica identifier"
  type        = string
}

variable "dr_desired_capacity" {
  description = "Desired DR capacity during failover"
  type        = number
  default     = 2
}

variable "lambda_source_file" {
  description = "Path to the Lambda Python source file"
  type        = string
}

variable "dry_run" {
  description = "Prevent real failover actions during initial testing"
  type        = bool
  default     = true
}