# 1. Terraform Settings
terraform {
  backend "s3" {
    bucket         = "tf-state-fundamental-ananlysis-dax-076360446836-eu-central-1"
    key            = "dev/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# 2. Provider
provider "aws" {
  region = "eu-central-1"
}

# 3. Primary Storage Bucket
resource "aws_s3_bucket" "primary_storage" {
  bucket = var.bucket_name

  tags = {
    Name        = "Primary Storage"
    Environment = var.env
  }
}

# --- NEW: Hardening for Primary Storage ---
resource "aws_s3_bucket_public_access_block" "primary_storage_lock" {
  bucket                  = aws_s3_bucket.primary_storage.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "primary_crypto" {
  bucket = aws_s3_bucket.primary_storage.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 4. S3 Bucket for Terraform State
resource "aws_s3_bucket" "terraform_state" {
  bucket = "tf-state-${var.bucket_name}"

  lifecycle {
    prevent_destroy = true
  }
}

# --- NEW: Hardening for State Bucket ---
resource "aws_s3_bucket_public_access_block" "state_lock" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_crypto" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 5. DynamoDB Table for State Locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  # --- NEW: Encryption for DynamoDB ---
  server_side_encryption {
    enabled = true
  }
}