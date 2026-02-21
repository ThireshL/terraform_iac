# 1. Terraform Settings: Defines the required plugins and versions
terraform {
  # This tells Terraform where to store the 'brain' of the project
  backend "s3" {
    bucket         = "tf-state-fundamental-ananlysis-dax-076360446836-eu-central-1"
    key            = "dev/terraform.tfstate" # This is the folder path inside the bucket
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

# 2. Provider: Configures the AWS connection to the Frankfurt region
provider "aws" {
  region = "eu-central-1"
}

# 3. S3 Bucket: The physical storage location for your data
resource "aws_s3_bucket" "primary_storage" {
  bucket = var.bucket_name # Pulls the name from variables.tf for consistency

  tags = {
    Name        = "Primary Storage"
    Environment = var.env # Pulls the environment name from variables.tf
  }
}
# 4. S3 Bucket for Terraform State (Remote Backend)
resource "aws_s3_bucket" "terraform_state" {
  bucket = "tf-state-${var.bucket_name}" # Unique name: tf-state-fundamental...

  # Prevent accidental deletion of this bucket
  lifecycle {
    prevent_destroy = true
  }
}

# Enable versioning so we can see old versions of our state if something breaks
resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 5. DynamoDB Table for State Locking
#resource "aws_iam_policy" "state_lock_policy" {
#  # (Optional: We'll keep it simple for now and just create the table)
#}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S" # String
  }
}
