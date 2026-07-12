module "networking" {
  source = "../../modules/networking"

  project_name = var.project_name
  environment  = var.environment

  vpc_cidr = "10.1.0.0/16"

  public_subnet_cidrs = [
    "10.1.1.0/24",
    "10.1.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.1.11.0/24",
    "10.1.12.0/24"
  ]

  availability_zones = [
    "us-west-2a",
    "us-west-2b"
  ]
}

module "security" {
  source = "../../modules/security"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.networking.vpc_id
}

module "iam" {
  source = "../../modules/iam"

  project_name = var.project_name
  environment  = var.environment
}

module "alb" {
  source = "../../modules/alb"

  project_name = var.project_name
  environment  = var.environment

  vpc_id                = module.networking.vpc_id
  public_subnet_ids     = module.networking.public_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
}

module "compute" {
  source = "../../modules/compute"

  project_name = var.project_name
  environment  = var.environment

  application_subnet_ids        = module.networking.public_subnet_ids
  application_security_group_id = module.security.application_security_group_id
  target_group_arn              = module.alb.target_group_arn
  instance_profile_name         = module.iam.instance_profile_name

  instance_type    = "t3.micro"
  minimum_capacity = 1
  desired_capacity = 1
  maximum_capacity = 2
}
resource "aws_kms_key" "rds_replica" {
  description             = "KMS key for DR RDS cross-region replica"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name = "AWS-Multi-Region-DR-dr-rds-key"
  }
}

resource "aws_kms_alias" "rds_replica" {
  name          = "alias/aws-multi-region-dr-dr-rds"
  target_key_id = aws_kms_key.rds_replica.key_id
}
module "database_replica" {
  source = "../../modules/database-replica"

  project_name = var.project_name
  environment  = var.environment

  source_db_arn = "arn:aws:rds:us-east-1:973008109674:db:aws-multi-region-dr-primary-postgres"

  database_subnet_ids = module.networking.private_subnet_ids

  database_security_group_id = module.security.database_security_group_id

  kms_key_arn = aws_kms_key.rds_replica.arn

  instance_class = "db.t3.micro"
}
module "failover_lambda" {
  source = "../../modules/failover-lambda"

  project_name = var.project_name
  environment  = var.environment

  dr_region             = "us-west-2"
  dr_asg_name           = module.compute.autoscaling_group_name
  dr_replica_identifier = module.database_replica.replica_identifier
  dr_desired_capacity   = 2

  lambda_source_file = "${path.root}/../../lambda/failover/lambda_function.py"

  # Keep enabled for safe testing.
  dry_run = true
}