variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "application_subnet_ids" {
  description = "Subnet IDs used by the Auto Scaling Group"
  type        = list(string)
}

variable "application_security_group_id" {
  description = "Application security group ID"
  type        = string
}

variable "target_group_arn" {
  description = "ALB target group ARN"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "minimum_capacity" {
  description = "Minimum ASG capacity"
  type        = number
  default     = 1
}

variable "desired_capacity" {
  description = "Desired ASG capacity"
  type        = number
  default     = 1
}

variable "maximum_capacity" {
  description = "Maximum ASG capacity"
  type        = number
  default     = 2
}
variable "instance_profile_name" {
  description = "IAM instance profile name for EC2 instances"
  type        = string
}