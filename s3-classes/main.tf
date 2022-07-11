terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22.0"
    }
  }
  backend "local" {
    path = "./.workspace/terraform.tfstate"
  }
}

provider "aws" {
  region = "sa-east-1"
}

### S3 ###
resource "aws_s3_bucket" "bucket" {
  bucket = "bucket-cloudfront-999"
}

resource "aws_s3_bucket_acl" "default" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}

# resource "aws_s3_bucket_policy" "cloudfront_oai" {
#   bucket = aws_s3_bucket.bucket.id
#   policy = data.aws_iam_policy_document.s3_policy.json
# }

# data "aws_iam_policy_document" "s3_policy" {
#   statement {
#     actions   = ["s3:GetObject"]
#     resources = ["${aws_s3_bucket.bucket.arn}/*"]

#     principals {
#       type        = "AWS"
#       identifiers = [aws_cloudfront_origin_access_identity.main.iam_arn]
#     }
#   }
# }

# resource "aws_s3_object" "index" {
#   bucket         = aws_s3_bucket.bucket.bucket
#   key            = "index.html"
#   content_base64 = filebase64("${path.module}/index.html")
# }

# resource "aws_s3_object" "saturn5" {
#   bucket         = aws_s3_bucket.bucket.bucket
#   key            = "saturn5.jpg"
#   content_base64 = filebase64("${path.module}/saturn5.jpg")
# }
