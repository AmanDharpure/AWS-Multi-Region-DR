module "networking" {
  source = "../../modules/networking"

  project_name = var.project_name
  environment  = var.environment

  vpc_cidr = "10.0.0.0/16"

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]

  availability_zones = [
    "us-east-1a",
    "us-east-1b"
  ]
}

module "security" {
  source = "../../modules/security"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.networking.vpc_id
}

module "alb" {
  source = "../../modules/alb"

  project_name = var.project_name
  environment  = var.environment

  vpc_id = module.networking.vpc_id

  public_subnet_ids = module.networking.public_subnet_ids

  alb_security_group_id = module.security.alb_security_group_id
}
module "iam" {
  source = "../../modules/iam"

  project_name = var.project_name
  environment  = var.environment
}
module "compute" {
  source = "../../modules/compute"

  project_name          = var.project_name
  environment           = var.environment
  instance_profile_name = module.iam.instance_profile_name

  application_subnet_ids        = module.networking.public_subnet_ids
  application_security_group_id = module.security.application_security_group_id
  target_group_arn              = module.alb.target_group_arn

  instance_type    = "t3.micro"
  minimum_capacity = 1
  desired_capacity = 1
  maximum_capacity = 2
}
module "database" {
  source = "../../modules/database"

  project_name    = var.project_name
  environment     = var.environment
  master_password = var.master_password

  database_subnet_ids = module.networking.private_subnet_ids

  database_security_group_id = module.security.database_security_group_id

  instance_class = "db.t3.micro"
}
module "monitoring" {
  source = "../../modules/monitoring"

  project_name = var.project_name
  environment  = var.environment

  notification_email = var.notification_email

  load_balancer_arn_suffix = module.alb.load_balancer_arn_suffix
  target_group_arn_suffix  = module.alb.target_group_arn_suffix

  autoscaling_group_name = module.compute.autoscaling_group_name
  database_identifier    = module.database.db_instance_identifier
}
module "failover_orchestrator" {
  source = "../../modules/failover-lambda"

  project_name = var.project_name
  environment  = "primary-orchestrator"

  dr_region             = "us-west-2"
  dr_asg_name           = "AWS-Multi-Region-DR-dr-asg"
  dr_replica_identifier = "aws-multi-region-dr-dr-postgres-replica"
  dr_desired_capacity   = 2

  lambda_source_file = "${path.root}/../../lambda/failover/lambda_function.py"

  dry_run = true
}
module "eventbridge" {
  source = "../../modules/eventbridge"

  project_name = var.project_name
  environment  = var.environment

  lambda_function_arn  = module.failover_orchestrator.lambda_function_arn
  lambda_function_name = module.failover_orchestrator.lambda_function_name

  alarm_name = module.monitoring.asg_alarm_name
}