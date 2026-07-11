output "instance_profile_name" {
  description = "IAM instance profile name for EC2"
  value       = aws_iam_instance_profile.ec2.name
}

output "ec2_role_name" {
  description = "IAM role name used by EC2"
  value       = aws_iam_role.ec2.name
}