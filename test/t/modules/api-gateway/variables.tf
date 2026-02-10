variable "region" {}
variable "vpc_id" {}
variable "subnet_ids" { type = list(string) }
variable "vpce_sg_id" {}
variable "lambda_invoke_arn" {}
variable "lambda_name" {}
