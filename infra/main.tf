terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" { region = "ap-southeast-2" }

data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals { type = "Service", identifiers = ["lambda.amazonaws.com"] }
  }
}

resource "aws_iam_role" "lambda" {
  name               = "mini-net9-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

resource "aws_lambda_function" "fn" {
  function_name = "mini-net9-image"
  package_type  = "Image"
  image_uri     = "445021790750.dkr.ecr.us-east-1.amazonaws.com/net/ai"
  role          = aws_iam_role.lambda.arn
}

resource "aws_lambda_function_url" "url" {
  function_name      = aws_lambda_function.fn.function_name
  authorization_type = "NONE"
}

output "function_url" {
  value = aws_lambda_function_url.url.function_url
}
