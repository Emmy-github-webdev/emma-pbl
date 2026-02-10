provider "aws" {
  region = var.region
}

data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

module "vpc" {
  source = "./modules/vpc"

  cidr_block         = "10.0.0.0/16"
  availability_zones = data.aws_availability_zones.available.names
}


module "security" {
  source   = "./modules/security"
  vpc_id  = module.vpc.vpc_id
  vpc_cidr = module.vpc.vpc_cidr
}

module "iam" {
  source = "./modules/iam"
}

module "lambda" {
  source              = "./modules/lambda"
  role_arn            = module.iam.lambda_role_arn
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [module.security.lambda_sg_id]
}

module "api_gateway" {
  source              = "./modules/api-gateway"
  region              = data.aws_region.current.name
  lambda_invoke_arn   = module.lambda.invoke_arn
  lambda_name         = module.lambda.function_name
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids
  vpce_sg_id          = module.security.vpce_sg_id
}
