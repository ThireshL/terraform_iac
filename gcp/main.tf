terraform {
  backend "gcs" {
    bucket      = "thire-tfstate-bucket-2026"
    prefix      = "terraform/state"
    credentials = "gcp-keys.json"
  }
}

# 1. Define the Google Provider using variables
provider "google" {
  credentials = file("gcp-keys.json")
  project     = var.project_id
  region      = var.region
}

# 2. Create the GCS Bucket for Terraform State
resource "google_storage_bucket" "terraform_state" {
  name          = "thire-tfstate-bucket-2026" 
  location      = var.location # Using variable here
  force_destroy = true 

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true
}

# 3. Create a BigQuery Dataset
resource "google_bigquery_dataset" "raw_data" {
  dataset_id                  = var.dataset_id # You can add this to variables.tf too
  friendly_name               = "Raw Data Warehouse"
  description                 = "This is the landing zone for raw data ingestion"
  location                    = var.location # Using variable here
  
  delete_contents_on_destroy = false

  labels = {
    env = "dev"
  }
}

# 4. Create the AWS Connection for BigQuery Omni
resource "google_bigquery_connection" "aws_s3_connection" {
  connection_id = "s3-link"
  location      = "aws-eu-central-1" # Connection locations are specific, usually left as is
  friendly_name = "Link to AWS S3"
  
  aws {
    access_role {
      iam_role_id = "arn:aws:iam::076360446836:role/bigquery-omni-role"
    }
  }
}