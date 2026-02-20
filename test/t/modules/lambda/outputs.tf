resource "aws_s3_bucket_policy" "allow_lambda_access" {
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowLambdaObjectAccess"
        Effect = "Allow"
        Principal = {
          AWS = var.lambda_role_arns
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.this.arn}/*"
      },
      {
        Sid    = "AllowLambdaListAccess"
        Effect = "Allow"
        Principal = {
          AWS = var.lambda_role_arns
        }
        Action   = "s3:ListBucket"
        Resource = aws_s3_bucket.this.arn
      }
    ]
  })
}