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
