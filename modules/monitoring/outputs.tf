output "sns_topic_arn" {
  description = "SNS topic ARN for monitoring alerts"
  value       = aws_sns_topic.alerts.arn
}

output "alb_alarm_name" {
  description = "ALB healthy host alarm name"
  value       = aws_cloudwatch_metric_alarm.alb_no_healthy_hosts.alarm_name
}

output "asg_alarm_name" {
  description = "ASG capacity alarm name"
  value       = aws_cloudwatch_metric_alarm.asg_low_capacity.alarm_name
}

output "rds_alarm_name" {
  description = "RDS CPU alarm name"
  value       = aws_cloudwatch_metric_alarm.rds_cpu_high.alarm_name
}