provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket  = "exittaskepam22"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.23.0"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform-state" {
  bucket = "exittaskepam"

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform-state-locking" {
  hash_key = "LockID"
  name     = "terraform-state-locking"
  attribute {
    name = "LockID"
    type = "S"
  }
  billing_mode = "PAY_PER_REQUEST"
}