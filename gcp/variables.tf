variable "project_id" {
  description = "The GCP Project ID"
  type        = string
  default     = "thire-multicloud-2026"
}

variable "region" {
  description = "The GCP region for resources"
  type        = string
  default     = "europe-west3"
}

variable "location" {
  description = "The multi-region location for BigQuery datasets"
  type        = string
  default     = "EU"
}
variable "dataset_id" {
  description = "The ID of the BigQuery dataset"
  type        = string
  default     = "raw_data"
}