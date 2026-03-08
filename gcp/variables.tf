variable "project_id" {
  description = "The GCP Project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for resources"
  type        = string
}

variable "location" {
  description = "The multi-region location for BigQuery datasets"
  type        = string
}

variable "dataset_id" {
  description = "The ID of the BigQuery dataset"
  type        = string
}

variable "billing_account_id" {
  description = "The ID of the billing account to associate this budget with"
  type        = string
}