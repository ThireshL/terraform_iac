terraform {
  backend "gcs" {
    bucket      = "thire-tfstate-bucket-2026"
    prefix      = "terraform/state"
    credentials = "gcp-keys.json"
  }
}

# 1. Define the Google Provider
provider "google" {
  credentials = fileexists("gcp-keys.json") ? file("gcp-keys.json") : null
  project     = var.project_id
  region      = var.region
}

# 2. NEW: Enable the Billing Budgets API (Fixes the 403 Error)
resource "google_project_service" "billing_budgets" {
  project            = var.project_id
  service            = "billingbudgets.googleapis.com"
  disable_on_destroy = false
}

# 3. Create the GCS Bucket for Terraform State
resource "google_storage_bucket" "terraform_state" {
  name          = "thire-tfstate-bucket-2026" 
  location      = var.location
  force_destroy = true 

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true
}

# 4. Create a BigQuery Dataset
resource "google_bigquery_dataset" "raw_data" {
  dataset_id                  = var.dataset_id
  friendly_name               = "Raw Data Warehouse"
  description                 = "This is the landing zone for raw data ingestion"
  location                    = var.location
  
  delete_contents_on_destroy = false

  labels = {
    env = "dev"
  }
}

# 5. Create the AWS Connection for BigQuery Omni
resource "google_bigquery_connection" "aws_s3_connection" {
  connection_id = "s3-link"
  location      = "aws-eu-central-1" 
  friendly_name = "Link to AWS S3"
  
  aws {
    access_role {
      iam_role_id = "arn:aws:iam::076360446836:role/bigquery-omni-role"
    }
  }
}

# 6. Create the Budget Alert (Now with API Dependency)
resource "google_billing_budget" "budget" {
  billing_account = var.billing_account_id
  display_name    = "Project Budget Alert"

  amount {
    specified_amount {
      currency_code = "USD"
      units         = "1"
    }
  }

  threshold_rules {
    threshold_percent = 0.5 
    spend_basis       = "CURRENT_SPEND"
  }

  threshold_rules {
    threshold_percent = 1.0 
    spend_basis       = "CURRENT_SPEND"
  }

  # This ensures the API is enabled BEFORE attempting to create the budget
  depends_on = [google_project_service.billing_budgets]
}