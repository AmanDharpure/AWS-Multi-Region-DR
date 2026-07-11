locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_launch_template" "application" {
  name_prefix   = "${local.name_prefix}-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  iam_instance_profile {
  name = var.instance_profile_name
}

  vpc_security_group_ids = [
    var.application_security_group_id
  ]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    dnf install -y nginx

    TOKEN=$(curl -s -X PUT \
      -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" \
      http://169.254.169.254/latest/api/token)

    REGION=$(curl -s \
      -H "X-aws-ec2-metadata-token: $TOKEN" \
      http://169.254.169.254/latest/meta-data/placement/region)

    INSTANCE_ID=$(curl -s \
      -H "X-aws-ec2-metadata-token: $TOKEN" \
      http://169.254.169.254/latest/meta-data/instance-id)

    cat > /usr/share/nginx/html/index.html <<HTML
    <!DOCTYPE html>
    <html>
    <head>
      <title>AWS Multi-Region DR</title>
    </head>
    <body>
      <h1>AWS Multi-Region Disaster Recovery</h1>
      <h2>Primary application is healthy</h2>
      <p>Region: $REGION</p>
      <p>Instance ID: $INSTANCE_ID</p>
    </body>
    </html>
    HTML

    echo "healthy" > /usr/share/nginx/html/health

    systemctl enable nginx
    systemctl start nginx
  EOF
  )

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${local.name_prefix}-app"
    }
  }
}

resource "aws_autoscaling_group" "application" {
  name = "${local.name_prefix}-asg"

  vpc_zone_identifier = var.application_subnet_ids

  min_size         = var.minimum_capacity
  desired_capacity = var.desired_capacity
  max_size         = var.maximum_capacity

  health_check_type         = "ELB"
  health_check_grace_period = 180

  target_group_arns = [
    var.target_group_arn
  ]

  launch_template {
    id      = aws_launch_template.application.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${local.name_prefix}-app"
    propagate_at_launch = true
  }
}