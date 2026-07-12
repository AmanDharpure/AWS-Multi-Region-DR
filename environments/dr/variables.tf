variable "project_name" {
  description = "Project name"
  type        = string
  default     = "AWS-Multi-Region-DR"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dr"
}

variable "region" {
  description = "AWS DR Region"
  type        = string
  default     = "us-west-2"
}