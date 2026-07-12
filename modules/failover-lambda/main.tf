data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = var.lambda_source_file
  output_path = "${path.module}/failover.zip"
}

resource "aws_iam_role" "lambda" {
  name = "${var.project_name}-${var.environment}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "lambda.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "basic" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "autoscaling" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
}

resource "aws_iam_role_policy_attachment" "rds" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_lambda_function" "failover" {
  function_name = "${var.project_name}-${var.environment}-failover"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  role    = aws_iam_role.lambda.arn
  handler = "lambda_function.lambda_handler"
  runtime = "python3.12"
  timeout = 60

  environment {
    variables = {
      DR_REGION              = var.dr_region
      DR_ASG_NAME            = var.dr_asg_name
      DR_REPLICA_IDENTIFIER  = var.dr_replica_identifier
      DR_DESIRED_CAPACITY    = tostring(var.dr_desired_capacity)
      DRY_RUN                = tostring(var.dry_run)
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.basic,
    aws_iam_role_policy_attachment.autoscaling,
    aws_iam_role_policy_attachment.rds
  ]
}