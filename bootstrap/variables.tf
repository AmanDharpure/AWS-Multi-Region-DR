variable "aws_region" {
  description = "AWS Region where the Terraform backend bucket will be created"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state"
  type        = string
}