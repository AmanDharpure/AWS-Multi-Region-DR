resource "aws_cloudwatch_event_rule" "dr_failover" {
  name        = "${var.project_name}-${var.environment}-failover-rule"
  description = "Invoke the DR failover Lambda when the primary ASG alarm enters ALARM"

  event_pattern = jsonencode({
    source = ["aws.cloudwatch"]

    "detail-type" = [
      "CloudWatch Alarm State Change"
    ]

    detail = {
      alarmName = [
        var.alarm_name
      ]

      state = {
        value = [
          "ALARM"
        ]
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule = aws_cloudwatch_event_rule.dr_failover.name
  arn  = var.lambda_function_arn
}

resource "aws_lambda_permission" "eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.dr_failover.arn
}