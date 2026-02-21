terraform {
  backend "gcs" {
    bucket      = "thire-tfstate-bucket-2026"
    prefix      = "terraform/state"
    credentials = "gcp-keys.json"
  }
}

# 1. Define the Google Provider
provider "google" {
  credentials = file("gcp-keys.json")
  project     = "thire-multicloud-2026"
  region      = "europe-west3" # Frankfurt - good for being in Germany
}

# 2. Create the GCS Bucket for Terraform State
resource "google_storage_bucket" "terraform_state" {
  name          = "thire-tfstate-bucket-2026" # Must be globally unique
  location      = "EU"
  force_destroy = true # Allows you to delete the bucket even if it's not empty

  # Enable versioning so we can recover old state files if needed
  versioning {
    enabled = true
  }

  # Best practice: uniform access for security
  uniform_bucket_level_access = true
}
# Create a BigQuery Dataset
resource "google_bigquery_dataset" "raw_data" {
  dataset_id                  = "raw_data"
  friendly_name               = "Raw Data Warehouse"
  description                 = "This is the landing zone for raw data ingestion"
  location                    = "EU" # Keeps data in Europe (Frankfurt/Belgium)
  
  # Protects your data - if you try to delete this via terraform, 
  # it will fail if there are tables inside.
  delete_contents_on_destroy = false

  labels = {
    env = "dev"
  }
}
# Create the AWS Connection for BigQuery Omni
resource "google_bigquery_connection" "aws_s3_connection" {
  connection_id = "s3-link"
  location      = "aws-eu-central-1" # This must match your AWS bucket region
  friendly_name = "Link to AWS S3"
  
  aws {
    access_role {
      # We will create this IAM Role in AWS in the next step
      iam_role_id = "arn:aws:iam::076360446836:role/bigquery-omni-role"
    }
  }
}