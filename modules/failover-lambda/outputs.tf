output "lambda_function_name" {
  description = "Name of the DR failover Lambda function"
  value       = aws_lambda_function.failover.function_name
}

output "lambda_function_arn" {
  description = "ARN of the DR failover Lambda function"
  value       = aws_lambda_function.failover.arn
}

output "lambda_role_arn" {
  description = "IAM role ARN used by the failover Lambda"
  value       = aws_iam_role.lambda.arn
}