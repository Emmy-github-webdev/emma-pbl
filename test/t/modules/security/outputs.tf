output "lambda_sg_id" {
  value = aws_security_group.lambda.id
}

output "vpce_sg_id" {
  value = aws_security_group.vpce.id
}
