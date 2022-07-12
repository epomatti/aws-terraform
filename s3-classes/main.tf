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

resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {
  bucket = aws_s3_bucket.bucket.bucket

  ###

  ### Logs ###
  rule {
    id = "log"

    expiration {
      days = 356
    }

    filter {
      and {
        prefix = "log/"

        tags = {
          rule      = "log"
          autoclean = "true"
        }
      }
    }

    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }

  ### Exclude Temporary ###
  rule {
    id = "tmp"

    filter {
      prefix = "tmp/"
    }

    expiration {
      days = 1
    }

    status = "Enabled"
  }
}


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
