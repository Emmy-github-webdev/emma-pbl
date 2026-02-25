resource "aws_iam_role" "lambda_role" {
  name = var.role_name

  assume_role_policy = data.aws_iam_policy_document.assume.json
}

data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "issuer_policy" {
  name = "${var.role_name}-policy"

  policy = data.aws_iam_policy_document.issuer.json
}

data "aws_iam_policy_document" "issuer" {

  statement {
    actions = ["secretsmanager:GetSecretValue"]
    resources = [var.secret_arn]
  }

  statement {
    actions = ["s3:GetObject"]
    resources = [
      "arn:aws:s3:::${var.bucket_name}/${var.allowed_prefix}*"
    ]
  }
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.issuer_policy.arn
}