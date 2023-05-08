terraform {
  required_version = ">= 0.13.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.66.1"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
    sid     = ""
  }
}

data "archive_file" "myzip" {
  type        = "zip"
  source_file = "main.py"
  output_path = "main.zip"
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

resource "aws_lambda_function" "mypython_lambda" {
  filename         = "main.zip"
  function_name    = "mypython_lambda_test"
  role             = aws_iam_role.mypython_lambda_role.arn
  handler          = "main.lambda_handler"
  runtime          = "python3.10"
  source_code_hash = "data.archive_file.myzip.output_base64sha256"
}

resource "aws_iam_role" "mypython_lambda_role" {
  name               = "mypython_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
